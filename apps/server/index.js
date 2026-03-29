require("dotenv").config();
const crypto = require("crypto");
const { Pool, Client } = require("pg");
const { WebSocketServer } = require("ws");

const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || "RFIDLab123!";

const DATABASE_URL = process.env.DATABASE_URL;
const WS_PORT = Number(process.env.WS_PORT) || 3001;

// --- Postgres pool for queries (inserting scans, etc.) ---
const pool = new Pool({ connectionString: DATABASE_URL });

// --- Dedicated Postgres client for LISTEN/NOTIFY ---
const listener = new Client({ connectionString: DATABASE_URL });

// --- WebSocket server ---
const wss = new WebSocketServer({ port: WS_PORT });

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

function json(res, status, obj) {
  res.writeHead(status, { "Content-Type": "application/json" });
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
    const toursResult = await pool.query(
      `SELECT id, company, ambassador_id, start_time, created_at
       FROM tours
       WHERE ambassador_id = $1 AND start_time IS NOT NULL
       ORDER BY ABS(EXTRACT(EPOCH FROM (start_time - NOW()))) ASC
       LIMIT 1`,
      [person.id]
    );

    if (toursResult.rows.length === 0) {
      broadcast({ type: "welcome", data: welcomePayloadFromRow(person) });
      return true;
    }

    const tour = toursResult.rows[0];
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
        start_time: tour.start_time
          ? new Date(tour.start_time).toISOString()
          : null,
        scanned_epc: person.epc,
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
  // 1. Clean slate for testing
  await pool.query("TRUNCATE tour_event RESTART IDENTITY");
  console.log("Truncated tour_event table");

  // 2. Connect the LISTEN client
  await listener.connect();
  await listener.query("LISTEN new_event");
  console.log("Listening for Postgres NOTIFY on channel: new_event");

  // 3. Forward every notification to all WebSocket clients
  listener.on("notification", async (msg) => {
    const event = JSON.parse(msg.payload);
    console.log("Event received:", event);
    broadcast({ type: "tour_event", data: event });

    // reader-2 is the welcome reader — ambassador roster or single welcome
    if (event.reader_id === "reader-2" && event.epc) {
      try {
        await broadcastWelcomeForEpc(event.epc);
      } catch (err) {
        console.error("Welcome lookup error:", err);
      }
    }

    // reader-3 is the lidar shelf reader — look up product and broadcast
    if (event.reader_id === "reader-3" && event.epc) {
      console.log("[lidar] reader-3 event, EPC:", event.epc);
      try {
        const result = await pool.query(
          "SELECT * FROM lidar_items WHERE epc = $1",
          [event.epc]
        );
        if (result.rows.length > 0) {
          const item = result.rows[0];
          console.log("[lidar] Match found:", item.item_desc, "— broadcasting lidar_scan");
          broadcast({
            type: "lidar_scan",
            data: {
              epc: item.epc,
              upc: item.upc,
              item_url: item.item_url,
              item_desc: item.item_desc,
            },
          });
        } else {
          console.log("[lidar] No match in lidar_items for EPC:", event.epc);
        }
      } catch (err) {
        console.error("Lidar lookup error:", err);
      }
    }
  });

  // 3. Accept WebSocket connections
  wss.on("connection", (ws) => {
    console.log("WebSocket client connected");
    ws.send(JSON.stringify({ type: "connected", message: "Listening for RFID scans" }));

    ws.on("close", () => console.log("WebSocket client disconnected"));
  });

  console.log(`WebSocket server running on ws://localhost:${WS_PORT}`);
}

// --- REST-style scan insert (for testing / RFID reader HTTP posts) ---
const http = require("http");

const httpServer = http.createServer(async (req, res) => {
  // CORS headers for frontend dev
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

  if (req.method === "OPTIONS") {
    res.writeHead(204);
    res.end();
    return;
  }

  const pathname = new URL(req.url, "http://localhost").pathname;

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
      res.writeHead(200, {
        "Content-Type": "text/csv; charset=utf-8",
        "Cache-Control": "no-store",
      });
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
            "SELECT id, company, ambassador_id, start_time, created_at FROM tours ORDER BY created_at DESC"
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
            const { company, ambassador_id, start_time } = body;
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
            const result = await pool.query(
              `INSERT INTO tours (company, ambassador_id, start_time) VALUES ($1,$2,$3) RETURNING *`,
              [String(company).trim(), aid, st]
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
            const { company, ambassador_id, start_time } = body;
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
            const result = await pool.query(
              `UPDATE tours SET company=$1, ambassador_id=$2, start_time=$3 WHERE id=$4::uuid RETURNING *`,
              [String(company).trim(), aid, st, tourId]
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

    json(res, 404, { error: "Not found" });
    return;
  }

  // POST /event — insert a tour_event row (triggers NOTIFY automatically)
  if (req.method === "POST" && req.url === "/event") {
    let body = "";
    req.on("data", (chunk) => (body += chunk));
    req.on("end", async () => {
      try {
        const e = JSON.parse(body);
        if (!e.event_id || !e.event_type || !e.event_ts) {
          res.writeHead(400, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ error: "event_id, event_type, and event_ts are required" }));
          return;
        }
        const result = await pool.query(
          `INSERT INTO tour_event (
            event_id, event_type, event_ts, site_id, reader_id, antenna_id,
            tour_id, epc, window_start_epoch_sec, window_end_epoch_sec,
            read_count_60s, unique_tag_count_60s, avg_rssi_60s,
            baseline_read_count, baseline_avg_rssi,
            count_drop_pct, rssi_drop_db,
            threshold_count_drop_pct, threshold_rssi_drop_db,
            consecutive_checks_required
          ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20)
          RETURNING *`,
          [
            e.event_id, e.event_type, e.event_ts, e.site_id, e.reader_id, e.antenna_id,
            e.tour_id, e.epc, e.window_start_epoch_sec, e.window_end_epoch_sec,
            e.read_count_60s, e.unique_tag_count_60s, e.avg_rssi_60s,
            e.baseline_read_count, e.baseline_avg_rssi,
            e.count_drop_pct, e.rssi_drop_db,
            e.threshold_count_drop_pct, e.threshold_rssi_drop_db,
            e.consecutive_checks_required
          ]
        );
        res.writeHead(201, { "Content-Type": "application/json" });
        res.end(JSON.stringify(result.rows[0]));
      } catch (err) {
        console.error("Insert error:", err);
        res.writeHead(500, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ error: "Internal server error" }));
      }
    });
    return;
  }

  // POST /welcome — reader near entrance picks up name tag EPCs, look up attendee and broadcast
  if (req.method === "POST" && req.url === "/welcome") {
    let body = "";
    req.on("data", (chunk) => (body += chunk));
    req.on("end", async () => {
      try {
        const { epc, reader_id } = JSON.parse(body);
        if (!epc) {
          res.writeHead(400, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ error: "epc is required" }));
          return;
        }

        // Look up who this tag belongs to
        const attendee = await pool.query(
          "SELECT * FROM people WHERE epc = $1",
          [epc]
        );

        if (attendee.rows.length === 0) {
          res.writeHead(404, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ error: "Unknown tag", epc }));
          return;
        }

        // Log the welcome event
        await pool.query(
          `INSERT INTO tour_event (event_id, event_type, event_ts, reader_id, epc)
           VALUES (gen_random_uuid(), 'welcome', NOW(), $1, $2)`,
          [reader_id || "welcome-antenna", epc]
        );

        const person = attendee.rows[0];
        await broadcastWelcomeForEpc(epc);

        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(
          JSON.stringify({ welcomed: person.first_name + " " + person.last_name })
        );
      } catch (err) {
        console.error("Welcome error:", err);
        res.writeHead(500, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ error: "Internal server error" }));
      }
    });
    return;
  }

  // GET /events — fetch recent tour events
  if (req.method === "GET" && req.url === "/events") {
    try {
      const result = await pool.query(
        "SELECT * FROM tour_event ORDER BY event_ts DESC LIMIT 50"
      );
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify(result.rows));
    } catch (err) {
      console.error("Query error:", err);
      res.writeHead(500, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: "Internal server error" }));
    }
    return;
  }

  // Health check
  if (req.method === "GET" && req.url === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "ok" }));
    return;
  }

  res.writeHead(404);
  res.end("Not found");
});

const HTTP_PORT = Number(process.env.HTTP_PORT) || 3002;
httpServer.listen(HTTP_PORT, () => {
  console.log(`HTTP server running on http://localhost:${HTTP_PORT}`);
});

start().catch((err) => {
  console.error("Failed to start:", err);
  process.exit(1);
});
