const path = require("path");
require("dotenv").config({ path: path.join(__dirname, ".env") });
const crypto = require("crypto");
const fs = require("fs");
const http = require("http");
const { Pool, Client } = require("pg");
const { WebSocketServer } = require("ws");
const { parse: parseYaml } = require("yaml");
const { insertRfidReadEvent, ADMIN_SIMULATE_SOURCE } = require("./lib/rfid-read-insert");

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

const LOCALIZATION_GRID_SIZE_FT = Number(process.env.LOCALIZATION_GRID_SIZE_FT || 6);
const LOCALIZATION_READER_ID = process.env.LOCALIZATION_READER_ID || "localize";
const LOCALIZATION_SITE_ID = process.env.LOCALIZATION_SITE_ID || "rfid-lab";
const LOCALIZATION_FRESH_MS = Number(process.env.LOCALIZATION_FRESH_MS || 8000);
const LOCALIZATION_REF_RSSI_DBM = Number(process.env.LOCALIZATION_REF_RSSI_DBM || -47);
const LOCALIZATION_PATH_LOSS_N = Number(process.env.LOCALIZATION_PATH_LOSS_N || 2.2);
const LOCALIZATION_REF_DISTANCE_FT = Number(
  process.env.LOCALIZATION_REF_DISTANCE_FT || 3.28084
);
const LOCALIZATION_MIN_DISTANCE_FT = Number(process.env.LOCALIZATION_MIN_DISTANCE_FT || 0.2);
const LOCALIZATION_MAX_DISTANCE_FT = Number(
  process.env.LOCALIZATION_MAX_DISTANCE_FT || LOCALIZATION_GRID_SIZE_FT * 2
);

const LOCALIZATION_ANCHORS = {
  1: { label: "localization-1", x: 0, y: 0 },
  2: { label: "localization-2", x: LOCALIZATION_GRID_SIZE_FT, y: 0 },
  3: {
    label: "localization-3",
    x: LOCALIZATION_GRID_SIZE_FT / 2,
    y: LOCALIZATION_GRID_SIZE_FT,
  },
};

const localizationStateByTag = new Map();

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

/** Human-readable reader/station name for tour conclusion / admin UI. */
function stationLabel(readerId) {
  const m = {
    welcome: "Welcome",
    "reader-2": "Welcome (legacy)",
    lidar: "LiDAR station",
    lidar_reader: "LiDAR station",
    "reader-3": "LiDAR (legacy)",
    "reader-1": "Station 1",
  };
  return m[readerId] ?? readerId;
}

const TOUR_UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

/**
 * Aggregates first/last scan per reader_id for everyone on the tour roster (visitors + ambassador).
 * @returns {Promise<{ data: { tour: object, stations: object[] } } | { error: number, message: string }>}
 */
async function tourStationSummaryPayload(pool, tourId) {
  if (!tourId || !TOUR_UUID_RE.test(String(tourId))) {
    return { error: 400, message: "tour_id query param must be a UUID" };
  }
  const tourResult = await pool.query(
    "SELECT id, company, logo, start_time FROM tours WHERE id = $1::uuid",
    [tourId]
  );
  if (tourResult.rows.length === 0) {
    return { error: 404, message: "Tour not found" };
  }
  const tour = tourResult.rows[0];
  const rosterResult = await pool.query(
    `SELECT DISTINCT epc FROM (
       SELECT epc FROM people WHERE tour_id = $1::uuid
       UNION
       SELECT p.epc FROM tours t
       INNER JOIN people p ON p.id = t.ambassador_id
       WHERE t.id = $1::uuid AND t.ambassador_id IS NOT NULL
     ) AS r
     WHERE epc IS NOT NULL AND TRIM(epc) <> ''`,
    [tourId]
  );
  const epcs = rosterResult.rows.map((r) => r.epc);
  const tourPayload = {
    id: tour.id,
    company: tour.company,
    logo: tour.logo,
    start_time: tour.start_time ? new Date(tour.start_time).toISOString() : null,
  };
  if (epcs.length === 0) {
    return { data: { tour: tourPayload, stations: [] } };
  }
  const aggResult = await pool.query(
    `SELECT
       r.reader_id,
       MIN(r.seen_at) AS first_ts,
       MAX(r.seen_at) AS last_ts,
       COUNT(*)::int AS event_count
     FROM rfid_read_event r
     WHERE r.epc = ANY($1::text[])
       AND r.reader_id IS NOT NULL
       AND TRIM(r.reader_id) <> ''
       AND ($2::timestamptz IS NULL OR r.seen_at >= $2::timestamptz)
     GROUP BY r.reader_id
     ORDER BY MIN(r.seen_at) ASC`,
    [epcs, tour.start_time ?? null]
  );
  const stations = aggResult.rows.map((row) => {
    const first = new Date(row.first_ts).getTime();
    const last = new Date(row.last_ts).getTime();
    const duration_ms = Math.max(0, last - first);
    return {
      reader_id: row.reader_id,
      label: stationLabel(row.reader_id),
      first_ts: new Date(row.first_ts).toISOString(),
      last_ts: new Date(row.last_ts).toISOString(),
      duration_ms,
      event_count: row.event_count,
    };
  });
  return { data: { tour: tourPayload, stations } };
}

/**
 * Tour to show on the public conclusion screen:
 * - Prefer the most recent tour that has already started (latest start_time <= now).
 *   When a newer tour's start time arrives, this automatically switches to that tour.
 * - If every tour is still in the future, use the earliest upcoming.
 * - If no start times exist, use the most recently created tour.
 */
async function resolveCurrentConclusionTourMeta(pool) {
  const started = await pool.query(
    `SELECT id FROM tours
     WHERE start_time IS NOT NULL AND start_time <= NOW()
     ORDER BY start_time DESC
     LIMIT 1`
  );
  if (started.rows.length) {
    return { id: started.rows[0].id, reason: "active" };
  }
  const upcoming = await pool.query(
    `SELECT id FROM tours
     WHERE start_time IS NOT NULL AND start_time > NOW()
     ORDER BY start_time ASC
     LIMIT 1`
  );
  if (upcoming.rows.length) {
    return { id: upcoming.rows[0].id, reason: "upcoming" };
  }
  const fallback = await pool.query(
    `SELECT id FROM tours ORDER BY created_at DESC LIMIT 1`
  );
  if (fallback.rows.length) {
    return { id: fallback.rows[0].id, reason: "latest_created" };
  }
  return null;
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
    role: person.role,
  };
}

/** UUID check for tour ids from query params / admin bodies. */
function isUuidString(s) {
  if (s == null || typeof s !== "string") return false;
  const t = s.trim();
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(t);
}

/** Welcome kiosk: canonical id `welcome`, legacy aggregators still send `reader-2`. */
function isWelcomeReaderId(readerId) {
  return readerId === "welcome" || readerId === "reader-2";
}

/** LiDAR shelf: canonical `lidar`, legacy `reader-3`, Zig host default alias `lidar_reader`. */
function isLidarReaderId(readerId) {
  return readerId === "lidar" || readerId === "reader-3" || readerId === "lidar_reader";
}

/** WebSocket payloads always use `welcome` so the browser can filter on one id. */
function canonicalWelcomeReaderId(readerId) {
  return isWelcomeReaderId(readerId) ? "welcome" : readerId;
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
 * Tour id for ambassador simulate: optional explicit tour_id (iPad / admin), else nearest by start_time; visitor → people.tour_id.
 * @param {{ id: number, role: string, tour_id?: string | null }} person
 * @param {string | null | undefined} optionalTourId — must already be validated for ambassadors when provided
 */
async function resolveTourIdForSimulatedEvent(person, optionalTourId) {
  if (person.role === "ambassador") {
    if (optionalTourId) {
      return optionalTourId;
    }
    const tour = await nearestTourForAmbassador(person.id);
    return tour ? tour.id : null;
  }
  return person.tour_id ?? null;
}

/**
 * Runs only from the Postgres NOTIFY listener (`new_rfid_read_event`).
 * HTTP routes that insert `rfid_read_event` must not duplicate welcome side effects — admin simulate broadcasts welcome in the HTTP handler.
 */
async function dispatchRfidReadFromNotify(row) {
  const normalized = {
    ...row,
    event_ts: row.seen_at,
    event_type: "tag_read",
  };
  broadcast({ type: "tour_event", data: normalized });

  const skipWelcomeInNotify = row.source === ADMIN_SIMULATE_SOURCE;

  if (isWelcomeReaderId(row.reader_id) && row.epc) {
    try {
      if (!skipWelcomeInNotify) {
        await broadcastWelcomeForEpc(row.epc, {
          reader_id: canonicalWelcomeReaderId(row.reader_id),
        });
      }
    } catch (err) {
      console.error("Welcome lookup error:", err);
    }
  }

  // Shelf reader — look up product and broadcast
  if (isLidarReaderId(row.reader_id) && row.epc) {
    console.log("[lidar] lidar reader event, EPC:", row.epc);
    try {
      const result = await pool.query(
        "SELECT * FROM lidar_items WHERE epc = $1",
        [row.epc]
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
        console.log("[lidar] No match in lidar_items for EPC:", row.epc);
      }
    } catch (err) {
      console.error("Lidar lookup error:", err);
    }
  }
}

function asFiniteNumber(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function parseEventMs(eventTs) {
  const t = new Date(eventTs).getTime();
  return Number.isFinite(t) ? t : Date.now();
}

function rssiToDistanceFt(rssi) {
  const rssiValue = asFiniteNumber(rssi);
  if (rssiValue == null) return null;
  const exponent = (LOCALIZATION_REF_RSSI_DBM - rssiValue) / (10 * LOCALIZATION_PATH_LOSS_N);
  const d = LOCALIZATION_REF_DISTANCE_FT * 10 ** exponent;
  if (!Number.isFinite(d)) return null;
  return clamp(d, LOCALIZATION_MIN_DISTANCE_FT, LOCALIZATION_MAX_DISTANCE_FT);
}

function trilaterate2d(a1, r1, a2, r2, a3, r3) {
  const A = 2 * (a2.x - a1.x);
  const B = 2 * (a2.y - a1.y);
  const C = r1 ** 2 - r2 ** 2 - a1.x ** 2 + a2.x ** 2 - a1.y ** 2 + a2.y ** 2;

  const D = 2 * (a3.x - a1.x);
  const E = 2 * (a3.y - a1.y);
  const F = r1 ** 2 - r3 ** 2 - a1.x ** 2 + a3.x ** 2 - a1.y ** 2 + a3.y ** 2;

  const det = A * E - B * D;
  if (Math.abs(det) < 1e-9) {
    return null;
  }

  const x = (C * E - B * F) / det;
  const y = (A * F - C * D) / det;
  if (!Number.isFinite(x) || !Number.isFinite(y)) {
    return null;
  }

  const residuals = [
    Math.hypot(x - a1.x, y - a1.y) - r1,
    Math.hypot(x - a2.x, y - a2.y) - r2,
    Math.hypot(x - a3.x, y - a3.y) - r3,
  ];
  const rmse = Math.sqrt(
    residuals.reduce((acc, v) => acc + v * v, 0) / residuals.length
  );

  return { x, y, residuals, rmse };
}

function computeLocalizationConfidence({ rmse, maxAgeMs, x, y }) {
  const rmseScale = LOCALIZATION_GRID_SIZE_FT * 0.75;
  const rmseScore = clamp(1 - rmse / rmseScale, 0, 1);
  const freshnessScore = clamp(1 - maxAgeMs / LOCALIZATION_FRESH_MS, 0, 1);
  const inBounds = x >= 0 && x <= LOCALIZATION_GRID_SIZE_FT && y >= 0 && y <= LOCALIZATION_GRID_SIZE_FT;
  const boundsScore = inBounds ? 1 : 0.35;
  return Number((rmseScore * 0.7 + freshnessScore * 0.2 + boundsScore * 0.1).toFixed(4));
}

async function tryInsertLocalizationEventFromLocalizeRead(event) {
  if (!event || !event.epc) return;

  const antennaId = Number(event.antenna_id);
  if (!Number.isInteger(antennaId) || !LOCALIZATION_ANCHORS[antennaId]) {
    return;
  }

  const rssi = asFiniteNumber(event.avg_rssi);
  if (rssi == null) return;

  const eventTsMs = parseEventMs(event.event_ts);
  const tagKey = `${event.epc}`;
  const entry = localizationStateByTag.get(tagKey) || { antennas: {} };
  entry.siteId = LOCALIZATION_SITE_ID;
  entry.readerId = LOCALIZATION_READER_ID;
  entry.epc = event.epc;
  entry.antennas[antennaId] = {
    rssi,
    eventTs: event.event_ts || new Date(eventTsMs).toISOString(),
    eventTsMs,
  };
  localizationStateByTag.set(tagKey, entry);

  const a1 = entry.antennas[1];
  const a2 = entry.antennas[2];
  const a3 = entry.antennas[3];
  if (!a1 || !a2 || !a3) return;

  const newestTsMs = Math.max(a1.eventTsMs, a2.eventTsMs, a3.eventTsMs);
  const oldestTsMs = Math.min(a1.eventTsMs, a2.eventTsMs, a3.eventTsMs);
  const maxAgeMs = newestTsMs - oldestTsMs;
  if (maxAgeMs > LOCALIZATION_FRESH_MS) return;

  const r1 = rssiToDistanceFt(a1.rssi);
  const r2 = rssiToDistanceFt(a2.rssi);
  const r3 = rssiToDistanceFt(a3.rssi);
  if (r1 == null || r2 == null || r3 == null) return;

  const solved = trilaterate2d(
    LOCALIZATION_ANCHORS[1],
    r1,
    LOCALIZATION_ANCHORS[2],
    r2,
    LOCALIZATION_ANCHORS[3],
    r3
  );
  if (!solved) return;

  const confidence = computeLocalizationConfidence({
    rmse: solved.rmse,
    maxAgeMs,
    x: solved.x,
    y: solved.y,
  });

  const xFt = Number(clamp(solved.x, 0, LOCALIZATION_GRID_SIZE_FT).toFixed(4));
  const yFt = Number(clamp(solved.y, 0, LOCALIZATION_GRID_SIZE_FT).toFixed(4));

  const sourceEventIds = {
    "localization-1": a1.eventTs,
    "localization-2": a2.eventTs,
    "localization-3": a3.eventTs,
  };
  const quality = {
    rmse_ft: Number(solved.rmse.toFixed(4)),
    residuals_ft: solved.residuals.map((v) => Number(v.toFixed(4))),
    freshness_span_ms: maxAgeMs,
    source_ages_ms: {
      "localization-1": newestTsMs - a1.eventTsMs,
      "localization-2": newestTsMs - a2.eventTsMs,
      "localization-3": newestTsMs - a3.eventTsMs,
    },
  };

  await pool.query(
    `INSERT INTO localization_event (
      event_id, event_ts, site_id, reader_id, epc, x_ft, y_ft, confidence,
      rssi_1, rssi_2, rssi_3, r1_ft, r2_ft, r3_ft, source_event_ids, quality
    ) VALUES (
      gen_random_uuid(), to_timestamp($1::double precision / 1000.0), $2, $3, $4, $5, $6, $7,
      $8, $9, $10, $11, $12, $13, $14::jsonb, $15::jsonb
    )`,
    [
      newestTsMs,
      entry.siteId,
      entry.readerId,
      entry.epc,
      xFt,
      yFt,
      confidence,
      a1.rssi,
      a2.rssi,
      a3.rssi,
      r1,
      r2,
      r3,
      JSON.stringify(sourceEventIds),
      JSON.stringify(quality),
    ]
  );
}

function pruneLocalizationState(nowMs) {
  const staleMs = Math.max(LOCALIZATION_FRESH_MS * 3, 15000);
  for (const [tagKey, state] of localizationStateByTag.entries()) {
    const antennas = state?.antennas || {};
    const latestSeen = Math.max(
      antennas[1]?.eventTsMs || 0,
      antennas[2]?.eventTsMs || 0,
      antennas[3]?.eventTsMs || 0
    );
    if (!latestSeen || nowMs - latestSeen > staleMs) {
      localizationStateByTag.delete(tagKey);
    }
  }
}

/**
 * Looks up EPC; ambassadors with a timed tour broadcast tour_roster.
 * Tour choice: nearest scheduled start for this ambassador, unless options.tour_id is set
 * (admin simulate / iPad only — never from broker NOTIFY payloads).
 */
async function broadcastWelcomeForEpc(epc, options = {}) {
  const explicitTourId =
    options.tour_id !== undefined && options.tour_id !== null
      ? options.tour_id
      : null;
  const readerId = options.reader_id ?? "welcome";

  const result = await pool.query(
    "SELECT *, role::text AS role FROM people WHERE epc = $1",
    [epc]
  );
  if (result.rows.length === 0) {
    return false;
  }

  const person = result.rows[0];

  if (person.role === "ambassador") {
    let tour = null;
    if (explicitTourId && isUuidString(explicitTourId)) {
      const tr = await pool.query(
        `SELECT id, company, logo, ambassador_id, start_time, created_at
         FROM tours
         WHERE id = $1::uuid AND ambassador_id = $2`,
        [explicitTourId, person.id]
      );
      tour = tr.rows.length > 0 ? tr.rows[0] : null;
    }
    if (!tour) {
      tour = await nearestTourForAmbassador(person.id);
    }

    if (!tour) {
      broadcast({
        type: "welcome",
        reader_id: readerId,
        data: welcomePayloadFromRow(person),
      });
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
      reader_id: readerId,
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

  broadcast({
    type: "welcome",
    reader_id: readerId,
    data: welcomePayloadFromRow(person),
  });
  return true;
}

// --- Boot sequence ---
async function start() {
  // Optional dev/demo reset — never default in production (e.g. Heroku).
  if (process.env.TRUNCATE_RFID_READ_EVENTS_ON_BOOT === "true") {
    await pool.query("TRUNCATE rfid_read_event, rfid_tag_live_state RESTART IDENTITY");
    console.log("Truncated rfid_read_event and rfid_tag_live_state");
  }

  // 2. Connect the LISTEN client
  await listener.connect();
  await listener.query("LISTEN new_rfid_read_event");
  await listener.query("LISTEN new_localize");
  await listener.query("LISTEN new_localization_event");
  console.log("Listening for Postgres NOTIFY on channel: new_rfid_read_event");
  console.log("Listening for Postgres NOTIFY on channel: new_localize");
  console.log("Listening for Postgres NOTIFY on channel: new_localization_event");

  setInterval(() => {
    pruneLocalizationState(Date.now());
  }, 10000).unref?.();

  // 3. NOTIFY → WebSocket (same path for real writers, simulate inserts, etc.)
  listener.on("notification", async (msg) => {
    let payload;
    try {
      payload = JSON.parse(msg.payload);
    } catch (err) {
      console.error("Notification handler error:", err);
      return;
    }

    if (msg.channel === "new_localization_event") {
      broadcast({ type: "localization_event", data: payload });
      return;
    }

    if (msg.channel === "new_localize") {
      try {
        await tryInsertLocalizationEventFromLocalizeRead(payload);
      } catch (err) {
        console.error("Localize event processing error:", err);
      }
      return;
    }

    if (msg.channel !== "new_rfid_read_event") {
      return;
    }

    console.log("RFID read received:", payload);

    try {
      await dispatchRfidReadFromNotify(payload);
    } catch (err) {
      console.error("RFID read dispatch error:", err);
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

  // GET /api/tours — public read-only list (kiosk / conclusion picker)
  if (req.method === "GET" && pathname === "/api/tours") {
    pool
      .query(
        `SELECT id, company, logo, ambassador_id, start_time, created_at FROM tours ORDER BY created_at DESC`
      )
      .then((result) => json(res, 200, result.rows))
      .catch((err) => {
        console.error("GET /api/tours:", err);
        json(res, 500, { error: "Database error" });
      });
    return;
  }

  // GET /api/conclusion-current — station summary for the current tour (or ?tour_id= override)
  if (req.method === "GET" && pathname === "/api/conclusion-current") {
    (async () => {
      try {
        const u = new URL(req.url, "http://localhost");
        const override = u.searchParams.get("tour_id");
        let meta = null;
        if (override && TOUR_UUID_RE.test(String(override))) {
          meta = { id: override, reason: null, mode: "override" };
        } else {
          const resolved = await resolveCurrentConclusionTourMeta(pool);
          if (!resolved) {
            json(res, 404, { error: "No tours" });
            return;
          }
          meta = { id: resolved.id, reason: resolved.reason, mode: "current" };
        }
        const out = await tourStationSummaryPayload(pool, meta.id);
        if (out.error) {
          json(res, out.error, { error: out.message });
          return;
        }
        json(res, 200, {
          ...out.data,
          selection: {
            mode: meta.mode,
            reason: meta.reason,
          },
        });
      } catch (err) {
        console.error("GET /api/conclusion-current:", err);
        json(res, 500, { error: "Database error" });
      }
    })();
    return;
  }

  // GET /api/tour-station-summary?tour_id=UUID — dwell per station for tour group (public kiosk)
  if (req.method === "GET" && pathname === "/api/tour-station-summary") {
    (async () => {
      try {
        const u = new URL(req.url, "http://localhost");
        const tourId = u.searchParams.get("tour_id");
        const out = await tourStationSummaryPayload(pool, tourId);
        if (out.error) {
          json(res, out.error, { error: out.message });
          return;
        }
        json(res, 200, out.data);
      } catch (err) {
        console.error("GET /api/tour-station-summary:", err);
        json(res, 500, { error: "Database error" });
      }
    })();
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

    // GET/POST /api/admin/lidar-items — shelf catalog for lidar reader → lidar_scan WebSocket
    // PUT/DELETE /api/admin/lidar-items/:epc
    if (segments[0] === "lidar-items") {
      if (req.method === "GET" && segments.length === 1) {
        pool
          .query(
            "SELECT epc, upc, item_url, item_desc FROM lidar_items ORDER BY epc ASC"
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
            const epc = typeof body.epc === "string" ? body.epc.trim() : "";
            if (!epc) {
              json(res, 400, { error: "epc is required" });
              return;
            }
            const upc =
              body.upc != null && String(body.upc).trim() !== ""
                ? String(body.upc).trim()
                : null;
            const itemUrl =
              body.item_url != null && String(body.item_url).trim() !== ""
                ? String(body.item_url).trim()
                : null;
            const itemDesc =
              body.item_desc != null && String(body.item_desc).trim() !== ""
                ? String(body.item_desc).trim()
                : null;
            const result = await pool.query(
              `INSERT INTO lidar_items (epc, upc, item_url, item_desc) VALUES ($1,$2,$3,$4)
               RETURNING epc, upc, item_url, item_desc`,
              [epc, upc, itemUrl, itemDesc]
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

      if (segments.length === 2) {
        const epcKey = decodeURIComponent(segments[1]);
        if (req.method === "PUT") {
          readJsonBody(req)
            .then(async (body) => {
              const upc =
                body.upc != null && String(body.upc).trim() !== ""
                  ? String(body.upc).trim()
                  : null;
              const itemUrl =
                body.item_url != null && String(body.item_url).trim() !== ""
                  ? String(body.item_url).trim()
                  : null;
              const itemDesc =
                body.item_desc != null && String(body.item_desc).trim() !== ""
                  ? String(body.item_desc).trim()
                  : null;
              const result = await pool.query(
                `UPDATE lidar_items SET upc = $1, item_url = $2, item_desc = $3 WHERE epc = $4
                 RETURNING epc, upc, item_url, item_desc`,
                [upc, itemUrl, itemDesc, epcKey]
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
        if (req.method === "DELETE") {
          pool
            .query("DELETE FROM lidar_items WHERE epc = $1 RETURNING epc", [epcKey])
            .then((result) => {
              if (result.rows.length === 0) {
                json(res, 404, { error: "Not found" });
                return;
              }
              json(res, 200, { deleted: epcKey });
            })
            .catch((err) => {
              console.error(err);
              json(res, 500, { error: "Database error" });
            });
          return;
        }
      }
    }

    // GET /api/admin/tour-events — recent rfid_read_event rows (for admin UI)
    // DELETE /api/admin/tour-events — truncate RFID tables (dev / reset)
    if (segments[0] === "tour-events" && segments.length === 1) {
      if (req.method === "GET") {
        pool
          .query(
            `SELECT r.id, r.reader_id, r.antenna_id, r.epc, r.seen_at, r.rssi_dbm, r.source, r.ingest_ts,
                    p.tour_id::text AS tour_id,
                    p.id AS person_id,
                    p.first_name AS person_first_name,
                    p.last_name AS person_last_name,
                    p.email AS person_email,
                    p.company AS person_company,
                    p.title AS person_title,
                    p.photo_url AS person_photo_url,
                    p.role::text AS person_role,
                    li.item_desc AS lidar_item_desc,
                    li.upc AS lidar_item_upc
             FROM rfid_read_event r
             LEFT JOIN people p ON p.epc = r.epc
             LEFT JOIN lidar_items li ON li.epc = r.epc
             ORDER BY r.seen_at DESC
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
          .query("TRUNCATE rfid_read_event, rfid_tag_live_state RESTART IDENTITY")
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

    // POST /api/admin/show-conclusion-on-welcome — all /welcome kiosks navigate to thank-you (optional tour_id for deep link)
    if (segments[0] === "show-conclusion-on-welcome" && req.method === "POST" && segments.length === 1) {
      readJsonBody(req)
        .then((body) => {
          const tid =
            body.tour_id != null && String(body.tour_id).trim() !== ""
              ? String(body.tour_id).trim()
              : null;
          if (tid !== null && !isUuidString(tid)) {
            json(res, 400, { error: "tour_id must be a valid UUID when provided" });
            return;
          }
          broadcast({ type: "welcome_show_conclusion", data: { tour_id: tid } });
          json(res, 200, { ok: true });
        })
        .catch(() => json(res, 400, { error: "Invalid JSON" }));
      return;
    }

    // POST /api/admin/simulate-tour-event — DB insert only; NOTIFY/LISTEN drives WebSocket (same as POST /event)
    if (segments[0] === "simulate-tour-event" && req.method === "POST" && segments.length === 1) {
      readJsonBody(req)
        .then(async (body) => {
          const readerForSim =
            body.reader_id != null && String(body.reader_id).trim() !== ""
              ? String(body.reader_id).trim()
              : "welcome";
          const personId = body.person_id != null ? Number(body.person_id) : null;
          const epcDirect =
            typeof body.epc === "string" && body.epc.trim() !== "" ? body.epc.trim() : null;
          if (!personId && !epcDirect) {
            json(res, 400, { error: "person_id or epc is required" });
            return;
          }
          /** @type {{ id: number, epc: string, role: string, tour_id?: string | null } | null} */
          let personRow = null;
          let epc;

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
            epc = personRow.epc;
          } else if (isLidarReaderId(readerForSim)) {
            const li = await pool.query("SELECT epc FROM lidar_items WHERE epc = $1", [epcDirect]);
            if (li.rows.length === 0) {
              json(res, 404, { error: "LiDAR item not found for this EPC" });
              return;
            }
            epc = li.rows[0].epc;
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
            epc = personRow.epc;
          }

          const optionalTourId =
            typeof body.tour_id === "string" && body.tour_id.trim() !== ""
              ? body.tour_id.trim()
              : null;

          if (optionalTourId && personRow && personRow.role === "ambassador") {
            if (!isUuidString(optionalTourId)) {
              json(res, 400, {
                error: "tour_id must be a UUID (matches tours.id)",
              });
              return;
            }
            const checkTour = await pool.query(
              `SELECT id FROM tours WHERE id = $1::uuid AND ambassador_id = $2`,
              [optionalTourId, personRow.id]
            );
            if (checkTour.rows.length === 0) {
              json(res, 400, {
                error: "tour_id must be a tour assigned to this ambassador",
              });
              return;
            }
          }

          let resolvedTourId = null;
          if (personRow) {
            resolvedTourId = await resolveTourIdForSimulatedEvent(personRow, optionalTourId);
          }

          const antennaNum = Number(body.antenna_id);
          const antennaId = Number.isFinite(antennaNum) ? Math.trunc(antennaNum) : 1;

          const result = await insertRfidReadEvent(pool, {
            reader_id: readerForSim,
            antenna_id: antennaId,
            epc,
            seen_at: new Date().toISOString(),
            rssi_dbm: null,
            source: ADMIN_SIMULATE_SOURCE,
          });

          // Welcome roster: only from server-side person/tour resolution — never from broker row fields.
          if (isWelcomeReaderId(readerForSim) && personRow) {
            try {
              await broadcastWelcomeForEpc(epc, {
                tour_id:
                  personRow.role === "ambassador" &&
                  optionalTourId &&
                  isUuidString(optionalTourId)
                    ? resolvedTourId
                    : null,
                reader_id: "welcome",
              });
            } catch (err) {
              console.error("Welcome broadcast after simulate:", err);
            }
          }

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

  // POST /event — insert `rfid_read_event` (triggers NOTIFY `new_rfid_read_event`)
  if (req.method === "POST" && pathname === "/event") {
    let body = "";
    req.on("data", (chunk) => (body += chunk));
    req.on("end", async () => {
      try {
        const e = JSON.parse(body);
        if (!e.reader_id || e.antenna_id == null || !e.epc) {
          res.writeHead(
            400,
            withCors({ "Content-Type": "application/json" })
          );
          res.end(
            JSON.stringify({
              error: "reader_id, antenna_id, and epc are required",
            })
          );
          return;
        }
        const antennaId = Number(e.antenna_id);
        if (!Number.isFinite(antennaId)) {
          res.writeHead(400, withCors({ "Content-Type": "application/json" }));
          res.end(JSON.stringify({ error: "antenna_id must be a number" }));
          return;
        }
        const result = await insertRfidReadEvent(pool, {
          reader_id: String(e.reader_id),
          antenna_id: Math.trunc(antennaId),
          epc: String(e.epc),
          seen_at: e.seen_at != null ? String(e.seen_at) : null,
          rssi_dbm: e.rssi_dbm != null ? Number(e.rssi_dbm) : null,
          source: e.source != null ? String(e.source) : "reader",
        });
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

  // GET /events — fetch recent RFID reads
  if (req.method === "GET" && pathname === "/events") {
    try {
      const result = await pool.query(
        "SELECT * FROM rfid_read_event ORDER BY seen_at DESC LIMIT 50"
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
