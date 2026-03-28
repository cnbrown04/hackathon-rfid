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
  await listener.query("LISTEN new_scan");
  console.log("Listening for Postgres NOTIFY on channel: new_scan");

  // 2. Forward every notification to all WebSocket clients
  listener.on("notification", (msg) => {
    const scan = JSON.parse(msg.payload);
    console.log("Scan received:", scan);
    broadcast({ type: "scan", data: scan });
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

  // POST /scan  — insert a scan row (triggers NOTIFY automatically)
  if (req.method === "POST" && req.url === "/scan") {
    let body = "";
    req.on("data", (chunk) => (body += chunk));
    req.on("end", async () => {
      try {
        const { tag_id, reader_id } = JSON.parse(body);
        if (!tag_id || !reader_id) {
          res.writeHead(400, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ error: "tag_id and reader_id required" }));
          return;
        }
        const result = await pool.query(
          "INSERT INTO scans (tag_id, reader_id) VALUES ($1, $2) RETURNING *",
          [tag_id, reader_id]
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

  // GET /scans — fetch recent scans
  if (req.method === "GET" && req.url === "/scans") {
    try {
      const result = await pool.query(
        "SELECT * FROM scans ORDER BY scanned_at DESC LIMIT 50"
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
