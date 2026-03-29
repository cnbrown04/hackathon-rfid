require("dotenv").config();
const crypto = require("crypto");
const fs = require("fs");
const http = require("http");
const path = require("path");
const { Pool, Client } = require("pg");
const { WebSocketServer } = require("ws");
const { parse: parseYaml } = require("yaml");
const { buildFakeTourEventBody, insertFullTourEvent } = require("./lib/tour-event-fake");

/** Parsed `openapi.yaml`, loaded once at first request to GET /openapi.json */
let openApiSpecCache = null;
function getOpenApiSpec() {
  if (openApiSpecCache) return openApiSpecCache;
  const yamlPath = path.join(__dirname, "openapi.yaml");
  const raw = fs.readFileSync(yamlPath, "utf8");
  openApiSpecCache = parseYaml(raw);
  return openApiSpecCache;
}

const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || "RFIDLab123!";

const DATABASE_URL = process.env.DATABASE_URL;

/** Heroku sets PORT; local dev often uses HTTP_PORT. */
const LISTEN_PORT = Number(process.env.PORT) || Number(process.env.HTTP_PORT) || 3002;

// --- Postgres pool for queries (inserting scans, etc.) ---
const pool = new Pool({ connectionString: DATABASE_URL });

// --- Dedicated Postgres client for LISTEN/NOTIFY ---
const listener = new Client({ connectionString: DATABASE_URL });

// --- WebSocket server (attached to HTTP server below; single port for PaaS like Heroku) ---
let wss;

function broadcast(data) {
  const msg = JSON.stringify(data);
  for (const client of wss.clients) {
    if (client.readyState === client.OPEN) {
      client.send(msg);
    }
  }
}

function timingSafeEqualString(a, b) {
  try {
    const bufA = Buffer.from(a, "utf8");
    const bufB = Buffer.from(b, "utf8");
    if (bufA.length !== bufB.length) return false;
    return crypto.timingSafeEqual(bufA, bufB);
  } catch {
    return false;
  }
}

function isAdminAuthorized(req) {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith("Bearer ")) return false;
  return timingSafeEqualString(auth.slice(7), ADMIN_PASSWORD);
}

function readJsonBody(req) {
  return new Promise((resolve, reject) => {
    let body = "";
    req.on("data", (chunk) => (body += chunk));
    req.on("end", () => {
      try {
        resolve(body ? JSON.parse(body) : {});
      } catch (e) {
        reject(e);
      }
    });
    req.on("error", reject);
  });
}

/** Merged into every HTTP response so browsers always see CORS (writeHead does not reliably keep prior setHeader). */
function corsHeaders() {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS",
    "Access-Control-Allow-Headers":
      "Content-Type, Authorization, X-Requested-With, Accept, Origin",
    "Access-Control-Max-Age": "86400",
  };
}

function withCors(extra = {}) {
  return { ...corsHeaders(), ...extra };
}

function json(res, status, obj) {
  res.writeHead(status, withCors({ "Content-Type": "application/json" }));
  res.end(JSON.stringify(obj));
}

function welcomePayloadFromRow(person) {
  return {
    first_name: person.first_name,
    last_name: person.last_name,
    email: person.email,
    company: person.company,
    title: person.title,
    photo_url: person.photo_url,
    epc: person.epc,
    arrived_at: new Date().toISOString(),
  };
}

/** Same tour pick as welcome roster: nearest scheduled start to now for this ambassador. */
async function nearestTourForAmbassador(ambassadorId) {
  const toursResult = await pool.query(
    `SELECT id, company, logo, ambassador_id, start_time, created_at
     FROM tours
     WHERE ambassador_id = $1 AND start_time IS NOT NULL
     ORDER BY ABS(EXTRACT(EPOCH FROM (start_time - NOW()))) ASC
     LIMIT 1`,
    [ambassadorId]
  );
  return toursResult.rows.length > 0 ? toursResult.rows[0] : null;
}

/**
 * tour_id stored on tour_event: ambassador → nearest tour by start_time; visitor → people.tour_id.
 */
async function resolveTourIdForSimulatedEvent(person) {
  if (person.role === "ambassador") {
    const tour = await nearestTourForAmbassador(person.id);
    return tour ? tour.id : null;
  }
  return person.tour_id ?? null;
}

/**
 * Runs only from the Postgres NOTIFY listener (INSERT → trigger → pg_notify).
 * HTTP routes that insert tour_event (POST /event, admin simulate, etc.) must not call this — the DB path is the single source of truth for WebSocket side effects.
 */
async function dispatchTourEventFromNotify(row) {
  broadcast({ type: "tour_event", data: row });

  if (row.reader_id === "reader-2" && row.epc) {
    try {
      await broadcastWelcomeForEpc(row.epc);
    } catch (err) {
      console.error("Welcome lookup error:", err);
    }
  }
}

/**
 * Looks up EPC; ambassadors with a timed tour broadcast tour_roster (nearest start_time to now),
 * otherwise a normal welcome message.
 */
async function broadcastWelcomeForEpc(epc) {
  const result = await pool.query(
    "SELECT *, role::text AS role FROM people WHERE epc = $1",
    [epc]
  );
  if (result.rows.length === 0) {
    return false;
  }

  const person = result.rows[0];

  if (person.role === "ambassador") {
    const tour = await nearestTourForAmbassador(person.id);

    if (!tour) {
      broadcast({ type: "welcome", data: welcomePayloadFromRow(person) });
      return true;
    }

    const rosterResult = await pool.query(
      `SELECT epc, first_name, last_name, email, company, title, photo_url
       FROM people
       WHERE tour_id = $1::uuid
       ORDER BY last_name ASC, first_name ASC`,
      [tour.id]
    );

    const people = rosterResult.rows.map((row) => ({
      first_name: row.first_name,
      last_name: row.last_name,
      email: row.email,
      company: row.company,
      title: row.title,
      photo_url: row.photo_url,
      epc: row.epc,
      arrived_at: "",
    }));

    broadcast({
      type: "tour_roster",
      data: {
        tour_id: tour.id,
        company: tour.company,
        logo: tour.logo ?? null,
        start_time: tour.start_time
          ? new Date(tour.start_time).toISOString()
          : null,
        scanned_epc: person.epc,
        scanned_at: new Date().toISOString(),
        people,
      },
    });
    return true;
  }

  broadcast({ type: "welcome", data: welcomePayloadFromRow(person) });
  return true;
}

// --- Boot sequence ---
async function start() {
  // Optional dev/demo reset — never default in production (e.g. Heroku).
  if (process.env.TRUNCATE_TOUR_EVENTS_ON_BOOT === "true") {
    await pool.query("TRUNCATE tour_event RESTART IDENTITY");
    console.log("Truncated tour_event table");
  }

  // 2. Connect the LISTEN client
  await listener.connect();
  await listener.query("LISTEN new_event");
  console.log("Listening for Postgres NOTIFY on channel: new_event");

  // 3. NOTIFY → WebSocket (same path for real writers, simulate inserts, etc.)
  listener.on("notification", async (msg) => {
    try {
      const event = JSON.parse(msg.payload);
      console.log("Event received:", event);
      await dispatchTourEventFromNotify(event);

      // reader-3 is the lidar shelf reader — look up product and broadcast
      if (event.reader_id === "reader-3" && event.epc) {
        try {
          const result = await pool.query(
            "SELECT * FROM lidar_items WHERE epc = $1",
            [event.epc]
          );
          if (result.rows.length > 0) {
            const item = result.rows[0];
            broadcast({
              type: "lidar_scan",
              data: {
                epc: item.epc,
                upc: item.upc,
                item_url: item.item_url,
                item_desc: item.item_desc,
              },
            });
          }
        } catch (err) {
          console.error("Lidar lookup error:", err);
        }
      }
    } catch (err) {
      console.error("Notification handler error:", err);
    }
  });

  // 3. Accept WebSocket connections
  wss.on("connection", (ws) => {
    console.log("WebSocket client connected");
    ws.send(JSON.stringify({ type: "connected", message: "Listening for RFID scans" }));

    ws.on("close", () => console.log("WebSocket client disconnected"));
  });

  console.log(`WebSocket listening on the same port as HTTP (${LISTEN_PORT})`);
}

// --- REST-style scan insert (for testing / RFID reader HTTP posts) ---
const httpServer = http.createServer(async (req, res) => {
  if (req.method === "OPTIONS") {
    res.writeHead(204, withCors());
    res.end();
    return;
  }

  let pathname;
  try {
    pathname = new URL(req.url, "http://localhost").pathname;
  } catch {
    json(res, 400, { error: "Bad request" });
    return;
  }

  // GET /openapi.json — OpenAPI document as JSON (admin UI, codegen, etc.)
  if (req.method === "GET" && pathname === "/openapi.json") {
    try {
      const spec = getOpenApiSpec();
      res.writeHead(
        200,
        withCors({
          "Content-Type": "application/json; charset=utf-8",
          "Cache-Control": "no-store",
        })
      );
      res.end(JSON.stringify(spec));
    } catch (err) {
      console.error("OpenAPI spec:", err);
      json(res, 500, { error: "OpenAPI spec unavailable" });
    }
    return;
  }

  // GET /api/epc-tour-map — EPC → tour UUID from people (for RFID host aggregator on startup)
  if (req.method === "GET" && pathname === "/api/epc-tour-map") {
    try {
      const result = await pool.query(
        `SELECT epc, tour_id::text AS tour_id
         FROM people
         WHERE tour_id IS NOT NULL
         ORDER BY epc ASC`
      );
      const lines = result.rows.map((row) => `${row.epc},${row.tour_id}`);
      res.writeHead(
        200,
        withCors({
          "Content-Type": "text/csv; charset=utf-8",
          "Cache-Control": "no-store",
        })
      );
      res.end(lines.join("\n") + (lines.length > 0 ? "\n" : ""));
    } catch (err) {
      console.error("epc-tour-map query:", err);
      json(res, 500, { error: "Database error" });
    }
    return;
  }

  // POST /api/admin/login — verify password (no Bearer required)
  if (req.method === "POST" && pathname === "/api/admin/login") {
    readJsonBody(req)
      .then((body) => {
        if (!timingSafeEqualString(String(body.password ?? ""), ADMIN_PASSWORD)) {
          json(res, 401, { error: "Invalid password" });
          return;
        }
        json(res, 200, { ok: true });
      })
      .catch(() => json(res, 400, { error: "Invalid JSON" }));
    return;
  }

  // --- Authenticated admin API ---
  const adminPrefix = "/api/admin/";
  if (pathname.startsWith(adminPrefix) && pathname !== "/api/admin/login") {
    if (!isAdminAuthorized(req)) {
      json(res, 401, { error: "Unauthorized" });
      return;
    }

    const rest = pathname.slice(adminPrefix.length);
    const segments = rest.split("/").filter(Boolean);

    const UUID_RE =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    function isUuid(s) {
      return typeof s === "string" && UUID_RE.test(s);
    }

    const TOUR_ROLES = new Set(["visitor", "ambassador"]);

    // people
    if (segments[0] === "people") {
      const id = segments[1] ? Number.parseInt(segments[1], 10) : null;

      if (req.method === "GET" && segments.length === 1) {
        pool
          .query(
            `SELECT id, epc, first_name, last_name, email, company, title, photo_url, created_at,
                    role::text AS role, tour_id
             FROM people ORDER BY id ASC`
          )
          .then((result) => json(res, 200, result.rows))
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }

      if (req.method === "POST" && segments.length === 1) {
        readJsonBody(req)
          .then(async (body) => {
            const {
              epc,
              first_name,
              last_name,
              email,
              company,
              title,
              photo_url,
              role,
              tour_id,
            } = body;
            if (!epc || !first_name || !last_name) {
              json(res, 400, { error: "epc, first_name, and last_name are required" });
              return;
            }
            const r = role && TOUR_ROLES.has(role) ? role : "visitor";
            const tid = tour_id != null && tour_id !== "" ? String(tour_id) : null;
            if (tid !== null && !isUuid(tid)) {
              json(res, 400, { error: "tour_id must be a valid UUID" });
              return;
            }
            const result = await pool.query(
              `INSERT INTO people (epc, first_name, last_name, email, company, title, photo_url, role, tour_id)
               VALUES ($1,$2,$3,$4,$5,$6,$7,$8::tour_role,$9)
               RETURNING id, epc, first_name, last_name, email, company, title, photo_url, created_at,
                         role::text AS role, tour_id`,
              [
                epc,
                first_name,
                last_name,
                email ?? null,
                company ?? null,
                title ?? null,
                photo_url ?? null,
                r,
                tid,
              ]
            );
            json(res, 201, result.rows[0]);
          })
          .catch((err) => {
            console.error(err);
            if (err.code === "23505") {
              json(res, 409, { error: "EPC already exists" });
            } else {
              json(res, 500, { error: "Database error" });
            }
          });
        return;
      }

      if (req.method === "PUT" && segments.length === 2 && id) {
        readJsonBody(req)
          .then(async (body) => {
            const {
              epc,
              first_name,
              last_name,
              email,
              company,
              title,
              photo_url,
              role,
              tour_id,
            } = body;
            if (!epc || !first_name || !last_name) {
              json(res, 400, { error: "epc, first_name, and last_name are required" });
              return;
            }
            if (!role || !TOUR_ROLES.has(role)) {
              json(res, 400, { error: "role must be visitor or ambassador" });
              return;
            }
            const tid = tour_id != null && tour_id !== "" ? String(tour_id) : null;
            if (tid !== null && !isUuid(tid)) {
              json(res, 400, { error: "tour_id must be a valid UUID" });
              return;
            }
            const result = await pool.query(
              `UPDATE people SET epc=$1, first_name=$2, last_name=$3, email=$4, company=$5, title=$6, photo_url=$7,
               role=$8::tour_role, tour_id=$9
               WHERE id=$10
               RETURNING id, epc, first_name, last_name, email, company, title, photo_url, created_at,
                         role::text AS role, tour_id`,
              [
                epc,
                first_name,
                last_name,
                email ?? null,
                company ?? null,
                title ?? null,
                photo_url ?? null,
                role,
                tid,
                id,
              ]
            );
            if (result.rows.length === 0) {
              json(res, 404, { error: "Not found" });
              return;
            }
            json(res, 200, result.rows[0]);
          })
          .catch((err) => {
            console.error(err);
            if (err.code === "23505") {
              json(res, 409, { error: "EPC already exists" });
            } else {
              json(res, 500, { error: "Database error" });
            }
          });
        return;
      }

      if (req.method === "DELETE" && segments.length === 2 && id) {
        pool
          .query("DELETE FROM people WHERE id = $1 RETURNING id", [id])
          .then((result) => {
            if (result.rows.length === 0) {
              json(res, 404, { error: "Not found" });
              return;
            }
            json(res, 200, { deleted: id });
          })
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }
    }

    // tours
    if (segments[0] === "tours") {
      const tourId = segments[1] ?? null;

      if (req.method === "GET" && segments.length === 1) {
        pool
          .query(
            "SELECT id, company, logo, ambassador_id, start_time, created_at FROM tours ORDER BY created_at DESC"
          )
          .then((result) => json(res, 200, result.rows))
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }

      if (req.method === "POST" && segments.length === 1) {
        readJsonBody(req)
          .then(async (body) => {
            const { company, ambassador_id, start_time, logo } = body;
            if (!company || String(company).trim() === "") {
              json(res, 400, { error: "company is required" });
              return;
            }
            const aid =
              ambassador_id != null && ambassador_id !== ""
                ? Number.parseInt(String(ambassador_id), 10)
                : null;
            if (aid != null && Number.isNaN(aid)) {
              json(res, 400, { error: "ambassador_id must be an integer" });
              return;
            }
            let st = null;
            if (start_time != null && start_time !== "") {
              const d = new Date(String(start_time));
              if (Number.isNaN(d.getTime())) {
                json(res, 400, { error: "start_time must be a valid ISO datetime" });
                return;
              }
              st = d.toISOString();
            }
            const logoVal =
              logo != null && String(logo).trim() !== "" ? String(logo).trim() : null;
            const result = await pool.query(
              `INSERT INTO tours (company, ambassador_id, start_time, logo) VALUES ($1,$2,$3,$4) RETURNING *`,
              [String(company).trim(), aid, st, logoVal]
            );
            json(res, 201, result.rows[0]);
          })
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }

      if (req.method === "PUT" && segments.length === 2 && tourId && isUuid(tourId)) {
        readJsonBody(req)
          .then(async (body) => {
            const { company, ambassador_id, start_time, logo } = body;
            if (!company || String(company).trim() === "") {
              json(res, 400, { error: "company is required" });
              return;
            }
            const aid =
              ambassador_id != null && ambassador_id !== ""
                ? Number.parseInt(String(ambassador_id), 10)
                : null;
            if (aid != null && Number.isNaN(aid)) {
              json(res, 400, { error: "ambassador_id must be an integer" });
              return;
            }
            let st = null;
            if (start_time != null && start_time !== "") {
              const d = new Date(String(start_time));
              if (Number.isNaN(d.getTime())) {
                json(res, 400, { error: "start_time must be a valid ISO datetime" });
                return;
              }
              st = d.toISOString();
            }
            const logoVal =
              logo != null && String(logo).trim() !== "" ? String(logo).trim() : null;
            const result = await pool.query(
              `UPDATE tours SET company=$1, ambassador_id=$2, start_time=$3, logo=$4 WHERE id=$5::uuid RETURNING *`,
              [String(company).trim(), aid, st, logoVal, tourId]
            );
            if (result.rows.length === 0) {
              json(res, 404, { error: "Not found" });
              return;
            }
            json(res, 200, result.rows[0]);
          })
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }

      if (req.method === "DELETE" && segments.length === 2 && tourId && isUuid(tourId)) {
        pool
          .query("DELETE FROM tours WHERE id = $1::uuid RETURNING id", [tourId])
          .then((result) => {
            if (result.rows.length === 0) {
              json(res, 404, { error: "Not found" });
              return;
            }
            json(res, 200, { deleted: tourId });
          })
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }
    }

    // GET /api/admin/tour-events — recent tour_event rows (for admin UI)
    // DELETE /api/admin/tour-events — truncate table (dev / reset)
    if (segments[0] === "tour-events" && segments.length === 1) {
      if (req.method === "GET") {
        pool
          .query(
            `SELECT te.id, te.event_id, te.event_type, te.event_ts, te.site_id, te.reader_id, te.antenna_id,
                    te.tour_id, te.epc, te.created_at,
                    p.id AS person_id,
                    p.first_name AS person_first_name,
                    p.last_name AS person_last_name,
                    p.email AS person_email,
                    p.company AS person_company,
                    p.title AS person_title,
                    p.photo_url AS person_photo_url,
                    p.role::text AS person_role
             FROM tour_event te
             LEFT JOIN people p ON p.epc = te.epc
             ORDER BY te.event_ts DESC
             LIMIT 40`
          )
          .then((result) => json(res, 200, result.rows))
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }

      if (req.method === "DELETE") {
        pool
          .query("TRUNCATE tour_event RESTART IDENTITY")
          .then(() => json(res, 200, { ok: true, deleted: "all" }))
          .catch((err) => {
            console.error(err);
            json(res, 500, { error: "Database error" });
          });
        return;
      }
    }

    // POST /api/admin/clear-welcome-screens — broadcast to all WebSocket clients (welcome page resets UI)
    if (segments[0] === "clear-welcome-screens" && req.method === "POST" && segments.length === 1) {
      broadcast({ type: "welcome_clear" });
      json(res, 200, { ok: true });
      return;
    }

    // POST /api/admin/simulate-tour-event — DB insert only; NOTIFY/LISTEN drives WebSocket (same as POST /event)
    if (segments[0] === "simulate-tour-event" && req.method === "POST" && segments.length === 1) {
      readJsonBody(req)
        .then(async (body) => {
          const personId = body.person_id != null ? Number(body.person_id) : null;
          const epcDirect =
            typeof body.epc === "string" && body.epc.trim() !== "" ? body.epc.trim() : null;
          if (!personId && !epcDirect) {
            json(res, 400, { error: "person_id or epc is required" });
            return;
          }
          let personRow;
          if (personId) {
            const pr = await pool.query(
              "SELECT id, epc, role::text AS role, tour_id FROM people WHERE id = $1",
              [personId]
            );
            if (pr.rows.length === 0) {
              json(res, 404, { error: "Person not found" });
              return;
            }
            personRow = pr.rows[0];
          } else {
            const pr = await pool.query(
              "SELECT id, epc, role::text AS role, tour_id FROM people WHERE epc = $1",
              [epcDirect]
            );
            if (pr.rows.length === 0) {
              json(res, 404, { error: "Person not found for EPC" });
              return;
            }
            personRow = pr.rows[0];
          }
          const epc = personRow.epc;
          const resolvedTourId = await resolveTourIdForSimulatedEvent(personRow);
          const fake = buildFakeTourEventBody(epc, {
            reader_id: body.reader_id,
            event_type: body.event_type,
            tour_id: resolvedTourId,
            site_id: body.site_id,
            antenna_id: body.antenna_id,
          });
          const result = await insertFullTourEvent(pool, fake);
          json(res, 201, result.rows[0]);
        })
        .catch((err) => {
          console.error(err);
          json(res, 500, { error: "Database error" });
        });
      return;
    }

    json(res, 404, { error: "Not found" });
    return;
  }

  // POST /event — insert a tour_event row (triggers NOTIFY automatically)
  if (req.method === "POST" && pathname === "/event") {
    let body = "";
    req.on("data", (chunk) => (body += chunk));
    req.on("end", async () => {
      try {
        const e = JSON.parse(body);
        if (!e.event_id || !e.event_type || !e.event_ts) {
          res.writeHead(
            400,
            withCors({ "Content-Type": "application/json" })
          );
          res.end(JSON.stringify({ error: "event_id, event_type, and event_ts are required" }));
          return;
        }
        const result = await insertFullTourEvent(pool, e);
        res.writeHead(201, withCors({ "Content-Type": "application/json" }));
        res.end(JSON.stringify(result.rows[0]));
      } catch (err) {
        console.error("Insert error:", err);
        res.writeHead(500, withCors({ "Content-Type": "application/json" }));
        res.end(JSON.stringify({ error: "Internal server error" }));
      }
    });
    return;
  }

  // GET /events — fetch recent tour events
  if (req.method === "GET" && pathname === "/events") {
    try {
      const result = await pool.query(
        "SELECT * FROM tour_event ORDER BY event_ts DESC LIMIT 50"
      );
      res.writeHead(200, withCors({ "Content-Type": "application/json" }));
      res.end(JSON.stringify(result.rows));
    } catch (err) {
      console.error("Query error:", err);
      res.writeHead(500, withCors({ "Content-Type": "application/json" }));
      res.end(JSON.stringify({ error: "Internal server error" }));
    }
    return;
  }

  // Health check
  if (req.method === "GET" && pathname === "/health") {
    res.writeHead(200, withCors({ "Content-Type": "application/json" }));
    res.end(JSON.stringify({ status: "ok" }));
    return;
  }

  res.writeHead(404, withCors({ "Content-Type": "text/plain; charset=utf-8" }));
  res.end("Not found");
});

wss = new WebSocketServer({ server: httpServer });

httpServer.listen(LISTEN_PORT, "0.0.0.0", () => {
  console.log(`HTTP server listening on port ${LISTEN_PORT}`);
});

start().catch((err) => {
  console.error("Failed to start:", err);
  process.exit(1);
});
