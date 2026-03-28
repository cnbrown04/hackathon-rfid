require("dotenv").config();
const { Pool, Client } = require("pg");
const { WebSocketServer } = require("ws");

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

// --- Boot sequence ---
async function start() {
  // 1. Connect the LISTEN client
  await listener.connect();
  await listener.query("LISTEN new_event");
  console.log("Listening for Postgres NOTIFY on channel: new_event");

  // 2. Forward every notification to all WebSocket clients
  listener.on("notification", (msg) => {
    const event = JSON.parse(msg.payload);
    console.log("Event received:", event);
    broadcast({ type: "tour_event", data: event });
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
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.writeHead(204);
    res.end();
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
            tour_id, epc, epc_list_csv, window_start_epoch_sec, window_end_epoch_sec,
            read_count_60s, unique_tag_count_60s, avg_rssi_60s,
            baseline_read_count, baseline_avg_rssi,
            count_drop_pct, rssi_drop_db,
            threshold_count_drop_pct, threshold_rssi_drop_db,
            consecutive_checks_required
          ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21)
          RETURNING *`,
          [
            e.event_id, e.event_type, e.event_ts, e.site_id, e.reader_id, e.antenna_id,
            e.tour_id, e.epc, e.epc_list_csv, e.window_start_epoch_sec, e.window_end_epoch_sec,
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
          "SELECT * FROM attendee WHERE epc = $1",
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

        // Broadcast to all WebSocket clients
        broadcast({
          type: "welcome",
          data: {
            first_name: person.first_name,
            last_name: person.last_name,
            company: person.company,
            title: person.title,
            photo_url: person.photo_url,
            epc: person.epc,
            arrived_at: new Date().toISOString(),
          },
        });

        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ welcomed: person.first_name + " " + person.last_name }));
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

const HTTP_PORT = Number(process.env.HTTP_PORT) || 3000;
httpServer.listen(HTTP_PORT, () => {
  console.log(`HTTP server running on http://localhost:${HTTP_PORT}`);
});

start().catch((err) => {
  console.error("Failed to start:", err);
  process.exit(1);
});
