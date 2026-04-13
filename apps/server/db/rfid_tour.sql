-- RFID: append-only raw reads + live row per (reader, antenna, EPC).
-- Apply after apps/server/db/setup.sql.

-- 1) Raw read stream from reader
CREATE TABLE IF NOT EXISTS rfid_read_event (
  id            BIGSERIAL PRIMARY KEY,
  reader_id     TEXT NOT NULL,
  antenna_id    INTEGER NOT NULL,
  epc           TEXT NOT NULL,
  seen_at       TIMESTAMPTZ NOT NULL,
  rssi_dbm      SMALLINT,
  ingest_ts     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  source        TEXT NOT NULL DEFAULT 'reader'
);

-- Older deployments: add column if missing (safe to re-run).
ALTER TABLE rfid_read_event ADD COLUMN IF NOT EXISTS source TEXT NOT NULL DEFAULT 'reader';

CREATE INDEX IF NOT EXISTS idx_rfid_read_event_seen_at
  ON rfid_read_event (seen_at DESC);

CREATE INDEX IF NOT EXISTS idx_rfid_read_event_epc_seen_at
  ON rfid_read_event (epc, seen_at DESC);

CREATE INDEX IF NOT EXISTS idx_rfid_read_event_reader_ant_seen_at
  ON rfid_read_event (reader_id, antenna_id, seen_at DESC);

-- 2) Current live state per reader/antenna/epc ("where is this badge now?")
CREATE TABLE IF NOT EXISTS rfid_tag_live_state (
  reader_id         TEXT NOT NULL,
  antenna_id        INTEGER NOT NULL,
  epc               TEXT NOT NULL,
  first_seen_at     TIMESTAMPTZ NOT NULL,
  last_seen_at      TIMESTAMPTZ NOT NULL,
  last_rssi_dbm     SMALLINT,
  total_read_count  BIGINT NOT NULL DEFAULT 1,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (reader_id, antenna_id, epc)
);

CREATE INDEX IF NOT EXISTS idx_rfid_tag_live_state_last_seen
  ON rfid_tag_live_state (last_seen_at DESC);

-- INSERT raw row -> upsert live state in the same transaction.
CREATE OR REPLACE FUNCTION upsert_rfid_live_state_from_raw()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO rfid_tag_live_state (
    reader_id, antenna_id, epc,
    first_seen_at, last_seen_at, last_rssi_dbm, total_read_count, updated_at
  ) VALUES (
    NEW.reader_id, NEW.antenna_id, NEW.epc,
    NEW.seen_at, NEW.seen_at, NEW.rssi_dbm, 1, NOW()
  )
  ON CONFLICT (reader_id, antenna_id, epc)
  DO UPDATE SET
    first_seen_at    = LEAST(rfid_tag_live_state.first_seen_at, EXCLUDED.first_seen_at),
    last_seen_at     = GREATEST(rfid_tag_live_state.last_seen_at, EXCLUDED.last_seen_at),
    last_rssi_dbm    = EXCLUDED.last_rssi_dbm,
    total_read_count = rfid_tag_live_state.total_read_count + 1,
    updated_at       = NOW();

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS rfid_read_event_live_trigger ON rfid_read_event;
CREATE TRIGGER rfid_read_event_live_trigger
  AFTER INSERT ON rfid_read_event
  FOR EACH ROW
  EXECUTE FUNCTION upsert_rfid_live_state_from_raw();

-- Optional: LISTEN/NOTIFY for push-style APIs.
CREATE OR REPLACE FUNCTION notify_new_rfid_read_event()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM pg_notify('new_rfid_read_event', row_to_json(NEW)::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS rfid_read_event_notify_trigger ON rfid_read_event;
CREATE TRIGGER rfid_read_event_notify_trigger
  AFTER INSERT ON rfid_read_event
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_rfid_read_event();
