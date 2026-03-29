const crypto = require("crypto");

/**
 * Builds a full tour_event payload matching POST /event (same columns as INSERT).
 * @param {string|null|undefined} epc
 * @param {Record<string, unknown>} [overrides]
 */
function buildFakeTourEventBody(epc, overrides = {}) {
  const o = overrides;
  const nowSec = Math.floor(Date.now() / 1000);
  const eventTs =
    typeof o.event_ts === "string" ? o.event_ts : new Date().toISOString();

  return {
    event_id: typeof o.event_id === "string" ? o.event_id : crypto.randomUUID(),
    event_type: typeof o.event_type === "string" ? o.event_type : "tag_read",
    event_ts: eventTs,
    site_id: o.site_id !== undefined && o.site_id !== null ? o.site_id : "lab-site-1",
    reader_id: o.reader_id !== undefined && o.reader_id !== null ? o.reader_id : "welcome",
    antenna_id: o.antenna_id !== undefined && o.antenna_id !== null ? o.antenna_id : 1,
    tour_id: o.tour_id !== undefined ? o.tour_id : null,
    epc: epc !== undefined && epc !== null ? String(epc) : null,
    window_start_epoch_sec:
      o.window_start_epoch_sec !== undefined && o.window_start_epoch_sec !== null
        ? o.window_start_epoch_sec
        : nowSec - 60,
    window_end_epoch_sec:
      o.window_end_epoch_sec !== undefined && o.window_end_epoch_sec !== null
        ? o.window_end_epoch_sec
        : nowSec,
    read_count_60s:
      o.read_count_60s !== undefined && o.read_count_60s !== null ? o.read_count_60s : 42,
    unique_tag_count_60s:
      o.unique_tag_count_60s !== undefined && o.unique_tag_count_60s !== null
        ? o.unique_tag_count_60s
        : 3,
    avg_rssi_60s:
      o.avg_rssi_60s !== undefined && o.avg_rssi_60s !== null ? o.avg_rssi_60s : -48.5,
    baseline_read_count:
      o.baseline_read_count !== undefined && o.baseline_read_count !== null
        ? o.baseline_read_count
        : 100,
    baseline_avg_rssi:
      o.baseline_avg_rssi !== undefined && o.baseline_avg_rssi !== null
        ? o.baseline_avg_rssi
        : -45,
    count_drop_pct:
      o.count_drop_pct !== undefined && o.count_drop_pct !== null ? o.count_drop_pct : 5,
    rssi_drop_db:
      o.rssi_drop_db !== undefined && o.rssi_drop_db !== null ? o.rssi_drop_db : 2,
    threshold_count_drop_pct:
      o.threshold_count_drop_pct !== undefined && o.threshold_count_drop_pct !== null
        ? o.threshold_count_drop_pct
        : 10,
    threshold_rssi_drop_db:
      o.threshold_rssi_drop_db !== undefined && o.threshold_rssi_drop_db !== null
        ? o.threshold_rssi_drop_db
        : 3,
    consecutive_checks_required:
      o.consecutive_checks_required !== undefined && o.consecutive_checks_required !== null
        ? o.consecutive_checks_required
        : 2,
  };
}

/**
 * @param {import("pg").Pool} pool
 * @param {ReturnType<typeof buildFakeTourEventBody>} e
 */
async function insertFullTourEvent(pool, e) {
  return pool.query(
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
      e.event_id,
      e.event_type,
      e.event_ts,
      e.site_id ?? null,
      e.reader_id ?? null,
      e.antenna_id ?? null,
      e.tour_id ?? null,
      e.epc ?? null,
      e.window_start_epoch_sec ?? null,
      e.window_end_epoch_sec ?? null,
      e.read_count_60s ?? null,
      e.unique_tag_count_60s ?? null,
      e.avg_rssi_60s ?? null,
      e.baseline_read_count ?? null,
      e.baseline_avg_rssi ?? null,
      e.count_drop_pct ?? null,
      e.rssi_drop_db ?? null,
      e.threshold_count_drop_pct ?? null,
      e.threshold_rssi_drop_db ?? null,
      e.consecutive_checks_required ?? null,
    ]
  );
}

module.exports = { buildFakeTourEventBody, insertFullTourEvent };
