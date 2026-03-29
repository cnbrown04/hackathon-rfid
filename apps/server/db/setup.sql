-- Enum for people.role (extend values here if the DB adds more labels)
DO $$ BEGIN
  CREATE TYPE tour_role AS ENUM ('visitor', 'ambassador');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- Sequence preserved name for migrations from `attendee`
CREATE SEQUENCE IF NOT EXISTS attendee_id_seq;

-- tours first (people.tour_id references this; ambassador FK added after people exists)
CREATE TABLE IF NOT EXISTS tours (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  company character varying(255) NOT NULL,
  ambassador_id integer,
  start_time timestamp with time zone,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT tours_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS people (
  id integer NOT NULL DEFAULT nextval('attendee_id_seq'::regclass),
  epc text NOT NULL,
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text,
  company text,
  title text,
  photo_url text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  role tour_role NOT NULL DEFAULT 'visitor'::tour_role,
  tour_id uuid,
  CONSTRAINT attendee_pkey PRIMARY KEY (id),
  CONSTRAINT attendee_epc_key UNIQUE (epc),
  CONSTRAINT people_tour_id_fkey FOREIGN KEY (tour_id)
    REFERENCES public.tours (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL
);

ALTER TABLE tours DROP CONSTRAINT IF EXISTS tours_ambassador_id_fkey;
ALTER TABLE tours
  ADD CONSTRAINT tours_ambassador_id_fkey FOREIGN KEY (ambassador_id)
    REFERENCES public.people (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL;

ALTER TABLE tours ADD COLUMN IF NOT EXISTS start_time TIMESTAMPTZ;
ALTER TABLE tours ADD COLUMN IF NOT EXISTS logo TEXT;

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

-- Localization outputs derived from tour_event stream trilateration
CREATE TABLE IF NOT EXISTS localization_event (
  id               BIGSERIAL PRIMARY KEY,
  event_id         UUID UNIQUE NOT NULL,
  event_ts         TIMESTAMPTZ NOT NULL,
  site_id          TEXT,
  reader_id        TEXT,
  epc              TEXT NOT NULL,
  x_ft             DOUBLE PRECISION,
  y_ft             DOUBLE PRECISION,
  confidence       DOUBLE PRECISION,
  rssi_1           DOUBLE PRECISION,
  rssi_2           DOUBLE PRECISION,
  rssi_3           DOUBLE PRECISION,
  r1_ft            DOUBLE PRECISION,
  r2_ft            DOUBLE PRECISION,
  r3_ft            DOUBLE PRECISION,
  source_event_ids JSONB,
  quality          JSONB,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Notify function: fires on every new tour_event insert
CREATE OR REPLACE FUNCTION notify_new_event()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM pg_notify('new_event', row_to_json(NEW)::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION notify_new_localization_event()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM pg_notify('new_localization_event', row_to_json(NEW)::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger
DROP TRIGGER IF EXISTS tour_event_inserted ON tour_event;
CREATE TRIGGER tour_event_inserted
  AFTER INSERT ON tour_event
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_event();

DROP TRIGGER IF EXISTS localization_event_inserted ON localization_event;
CREATE TRIGGER localization_event_inserted
  AFTER INSERT ON localization_event
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_localization_event();

-- Lightweight localize reader events (real-time trilateration input)
CREATE TABLE IF NOT EXISTS localize (
  event_ts      TIMESTAMPTZ NOT NULL,
  antenna_id    INTEGER NOT NULL,
  epc           TEXT NOT NULL,
  avg_rssi      DOUBLE PRECISION,
  read_count    BIGINT
);

CREATE OR REPLACE FUNCTION notify_new_localize()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM pg_notify('new_localize', row_to_json(NEW)::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS localize_inserted ON localize;
CREATE TRIGGER localize_inserted
  AFTER INSERT ON localize
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_localize();
