-- Attendee: people with RFID name tags
CREATE TABLE IF NOT EXISTS attendee (
  id         SERIAL PRIMARY KEY,
  epc        TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  last_name  TEXT NOT NULL,
  email      TEXT,
  company    TEXT,
  title      TEXT,
  photo_url  TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tour events: rich RFID read events from the reader
CREATE TABLE IF NOT EXISTS tour_event (
  id                          BIGSERIAL PRIMARY KEY,
  event_id                    UUID UNIQUE NOT NULL,
  event_type                  TEXT NOT NULL,
  event_ts                    TIMESTAMPTZ NOT NULL,
  site_id                     TEXT,
  reader_id                   TEXT,
  antenna_id                  INTEGER,
  tour_id                     TEXT,
  epc                         TEXT,
  epc_list_csv                TEXT,
  window_start_epoch_sec      BIGINT,
  window_end_epoch_sec        BIGINT,
  read_count_60s              BIGINT,
  unique_tag_count_60s        BIGINT,
  avg_rssi_60s                DOUBLE PRECISION,
  baseline_read_count         DOUBLE PRECISION,
  baseline_avg_rssi           DOUBLE PRECISION,
  count_drop_pct              DOUBLE PRECISION,
  rssi_drop_db                DOUBLE PRECISION,
  threshold_count_drop_pct    DOUBLE PRECISION,
  threshold_rssi_drop_db      DOUBLE PRECISION,
  consecutive_checks_required INTEGER,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Notify function: fires on every new tour_event insert
CREATE OR REPLACE FUNCTION notify_new_event()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM pg_notify('new_event', row_to_json(NEW)::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger
DROP TRIGGER IF EXISTS tour_event_inserted ON tour_event;
CREATE TRIGGER tour_event_inserted
  AFTER INSERT ON tour_event
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_event();
