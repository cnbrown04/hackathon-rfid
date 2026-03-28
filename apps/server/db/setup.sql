-- Attendees: people with RFID name tags
CREATE TABLE IF NOT EXISTS attendees (
  id         SERIAL PRIMARY KEY,
  epc        TEXT UNIQUE NOT NULL,        -- the EPC encoded on their name tag
  first_name TEXT NOT NULL,
  last_name  TEXT NOT NULL,
  email      TEXT,
  company    TEXT,
  title      TEXT,
  photo_url  TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create the scans table
CREATE TABLE IF NOT EXISTS scans (
  id         SERIAL PRIMARY KEY,
  tag_id     TEXT NOT NULL,
  reader_id  TEXT NOT NULL,
  scanned_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Notify function: fires on every new scan insert
CREATE OR REPLACE FUNCTION notify_new_scan()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM pg_notify('new_scan', row_to_json(NEW)::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger
DROP TRIGGER IF EXISTS scan_inserted ON scans;
CREATE TRIGGER scan_inserted
  AFTER INSERT ON scans
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_scan();
