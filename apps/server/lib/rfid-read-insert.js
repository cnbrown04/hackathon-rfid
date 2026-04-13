/**
 * Insert into `rfid_read_event` (see `apps/server/db/rfid_tour.sql`).
 * Triggers NOTIFY `new_rfid_read_event` for the Node listener.
 *
 * @param {import("pg").Pool} pool
 * @param {{
 *   reader_id: string,
 *   antenna_id: number,
 *   epc: string,
 *   seen_at?: string | Date | null,
 *   rssi_dbm?: number | null,
 *   source?: string | null,
 * }} row
 */
async function insertRfidReadEvent(pool, row) {
  const source = row.source != null && String(row.source).trim() !== "" ? String(row.source) : "reader";
  let seenAt = row.seen_at ?? null;
  if (seenAt instanceof Date) {
    seenAt = seenAt.toISOString();
  }
  return pool.query(
    `INSERT INTO rfid_read_event (reader_id, antenna_id, epc, seen_at, rssi_dbm, source)
     VALUES ($1, $2, $3, COALESCE($4::timestamptz, NOW()), $5::smallint, $6)
     RETURNING *`,
    [
      row.reader_id,
      row.antenna_id,
      row.epc,
      seenAt,
      row.rssi_dbm ?? null,
      source,
    ]
  );
}

/** Admin simulate path: skip welcome in NOTIFY; HTTP handler broadcasts welcome. */
const ADMIN_SIMULATE_SOURCE = "admin_simulate";

module.exports = { insertRfidReadEvent, ADMIN_SIMULATE_SOURCE };
