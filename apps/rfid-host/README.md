# RFID host (Zig)

## Run

```bash
cd apps/rfid-host
export LD_LIBRARY_PATH="$(pwd)/linux64_sdk/lib:${LD_LIBRARY_PATH:-}"

# Build
zig build

# Reader: fixed duration (seconds), port 5084
zig build run -- 169.254.57.58 30

# Reader: until SIGINT/SIGTERM (Ctrl+C), port 5084
zig build run -- 169.254.57.58 0

# Reader: custom port, run forever
zig build run -- 169.254.57.58 5085 0

# Helper (same as `<ip> 0` with LD_LIBRARY_PATH set)
./run-forever.sh 169.254.57.58
./run-forever.sh 169.254.57.58 5085
```

Copy **`.env.example`** → **`.env`** and set **`DATABASE_URL`** (and optional **`RFID_READER_ID`**) so reads insert into Postgres. Without **`DATABASE_URL`**, you only get JSON on stdout.

On shutdown (**Ctrl+C**, **`kill`**, or after the timed run), the app stops inventory, stops the consumer queue, closes Postgres, and disconnects from the reader (SDK `defer` order).

## Docker (arm + x86 hosts)

The Zebra SDK in `linux64_sdk` is x86-only, so the container is pinned to `linux/amd64`.
On arm64 machines (Apple Silicon, Graviton, etc.), Docker runs it through its translation/emulation layer automatically.

### Build and run locally (compose)

```bash
cd apps/rfid-host
cp .env.example .env
# edit .env and set DATABASE_URL / RFID_* values

# Build amd64 image (works on x86 hosts and arm hosts)
docker compose build

# Run forever on reader default LLRP port 5084
docker compose run --rm rfid-host 169.254.57.58 0

# Or custom port
docker compose run --rm rfid-host 169.254.57.58 5085 0
```

You can override the default compose command in `docker-compose.yml` if you want `docker compose up` behavior for a specific reader IP/port.

### Run the published GHCR image

The image is published at:
- `ghcr.io/cnbrown04/rfid-host:latest`
- `ghcr.io/cnbrown04/rfid-host:main`

```bash
cd apps/rfid-host
cp .env.example .env
# edit .env and set DATABASE_URL / RFID_* values

# Pull amd64 image explicitly (recommended on arm hosts)
docker pull --platform linux/amd64 ghcr.io/cnbrown04/rfid-host:latest

# Run forever on default reader LLRP port 5084
docker run --rm --platform linux/amd64 \
  --env-file .env \
  ghcr.io/cnbrown04/rfid-host:latest \
  169.254.57.58 0

# Or custom reader port
docker run --rm --platform linux/amd64 \
  --env-file .env \
  ghcr.io/cnbrown04/rfid-host:latest \
  169.254.57.58 5085 0
```

If you do not need DB writes, omit `--env-file .env`; the host prints JSON to stdout only.

## Test

**Database** (once per environment):

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f apps/server/db/setup.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f apps/server/db/rfid_tour.sql
```

**API / NOTIFY** (with **`apps/server`** running and **`DATABASE_URL`** in **`apps/server/.env`**):

```bash
cd apps/server && npm start
```

```bash
curl -sS -X POST "http://localhost:3002/event" \
  -H "Content-Type: application/json" \
  -d '{"reader_id":"welcome","antenna_id":1,"epc":"E2801160600002050668CA46"}'
```

Expect **201** and a row in **`rfid_read_event`** (and **`rfid_tag_live_state`** updated). Server logs should show **`new_rfid_read_event`** handling.

**Zig + hardware:** run the reader command above; confirm JSON lines and, with **`.env`**, new DB rows.

**Simulated tags (no reader):**

```bash
zig build run -- 15
```

(duration must be **> 0**)
