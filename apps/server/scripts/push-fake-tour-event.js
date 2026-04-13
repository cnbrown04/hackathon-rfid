#!/usr/bin/env node
/**
 * Insert fake rfid_read_event rows (same shape as POST /event).
 *
 * Usage:
 *   node scripts/push-fake-tour-event.js --epc E2801160600002050668CA46
 *   node scripts/push-fake-tour-event.js --person-id 3 --count 2
 *   node scripts/push-fake-tour-event.js --epc ... --direct   # pg insert, no HTTP server
 *
 * Env: DATABASE_URL (required for --person-id or --direct), HTTP_PORT (default 3002 for HTTP mode)
 */

const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env") });
const { Pool } = require("pg");
const { insertRfidReadEvent } = require("../lib/rfid-read-insert");

function parseArgs() {
  const argv = process.argv.slice(2);
  const httpPort = Number(process.env.HTTP_PORT) || 3002;
  const out = {
    count: 1,
    baseUrl: `http://localhost:${httpPort}`,
    direct: false,
    reader_id: "welcome",
    antenna_id: 1,
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--epc") out.epc = argv[++i];
    else if (a === "--person-id") out.personId = Number(argv[++i]);
    else if (a === "--count") out.count = Math.max(1, Number(argv[++i]) || 1);
    else if (a === "--url" || a === "--base-url") out.baseUrl = argv[++i];
    else if (a === "--direct") out.direct = true;
    else if (a === "--reader-id") out.reader_id = argv[++i];
    else if (a === "--antenna-id") out.antenna_id = Number(argv[++i]) || 1;
  }
  return out;
}

async function resolveEpc(args) {
  if (args.epc) return String(args.epc);
  if (!args.personId || Number.isNaN(args.personId)) {
    console.error("Provide --epc EPC or --person-id ID");
    process.exit(1);
  }
  if (!process.env.DATABASE_URL) {
    console.error("DATABASE_URL is required to resolve --person-id");
    process.exit(1);
  }
  const pool = new Pool({ connectionString: process.env.DATABASE_URL });
  try {
    const r = await pool.query("SELECT epc FROM people WHERE id = $1", [args.personId]);
    if (r.rows.length === 0) {
      console.error("Person not found");
      process.exit(1);
    }
    return r.rows[0].epc;
  } finally {
    await pool.end();
  }
}

async function main() {
  const args = parseArgs();
  const epc = await resolveEpc(args);

  if (args.direct) {
    if (!process.env.DATABASE_URL) {
      console.error("DATABASE_URL is required for --direct");
      process.exit(1);
    }
    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    try {
      for (let i = 0; i < args.count; i++) {
        const result = await insertRfidReadEvent(pool, {
          reader_id: args.reader_id,
          antenna_id: args.antenna_id,
          epc,
          seen_at: new Date().toISOString(),
          rssi_dbm: -48,
          source: "script",
        });
        const row = result.rows[0];
        console.log("Inserted", row.id, row.epc);
      }
    } finally {
      await pool.end();
    }
    return;
  }

  const base = args.baseUrl.replace(/\/$/, "");
  for (let i = 0; i < args.count; i++) {
    const body = {
      reader_id: args.reader_id,
      antenna_id: args.antenna_id,
      epc,
      seen_at: new Date().toISOString(),
      rssi_dbm: -48,
      source: "script",
    };
    const r = await fetch(`${base}/event`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    const text = await r.text();
    if (!r.ok) {
      console.error(`HTTP ${r.status}: ${text}`);
      process.exit(1);
    }
    const row = JSON.parse(text);
    console.log("Inserted", row.id, row.epc);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
