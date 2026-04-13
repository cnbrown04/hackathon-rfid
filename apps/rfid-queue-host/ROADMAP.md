# Roadmap: RFID → queue → ledger / Postgres → Docker (multi-arch)

This is a **plan only** (no implementation commitment here). Adjust order after spikes.

---

## Goals

1. **Decouple** the Zig reader process from downstream storage using a **durable message queue** (Kafka-class).
2. **Persist** business/ledger data in **TigerBeetle** (primary double-entry ledger) and use **PostgreSQL** where relational/query/reporting needs fit (see architecture note below).
3. **Ship** the Zig service (and related workers) in **Docker**, runnable on **linux/amd64** and **linux/arm64**.

---

## Architecture note: TigerBeetle vs PostgreSQL

- **TigerBeetle** is a separate replicated ledger engine (not “inside” Postgres). Typical pattern: TigerBeetle holds authoritative **transfers / balances**; **Postgres** holds app metadata, projections, or read models if needed.
- **Clarify in a short design doc** before build: which events become TigerBeetle transfers/accounts, what lands in Postgres (e.g. tag sightings, tour state, audit), and idempotency keys (EPC + time window, Kafka offsets, etc.).

---

## Phase A — Message queue (Kafka-class)

- [ ] **Pick broker**: Apache Kafka, Redpanda (Kafka-compatible), or lighter option (NATS JetStream) if team accepts non-Kafka semantics.
- [ ] **Define topic(s)** and schemas: e.g. `rfid.tag.read` with JSON or Avro/Protobuf (EPC, antenna, rssi, reader_id, event_time, dedupe_key).
- [ ] **Change Zig producer path**: today stdout JSON; add a **publisher** path (C SDK stays in-process) that produces to the broker with retries and metrics.
- [ ] **Local dev**: `docker compose` for broker + one consumer stub; document ports and env vars.

---

## Phase B — Consumers: TigerBeetle + Postgres

- [ ] **TigerBeetle cluster**: single-node dev / replicated prod; define clusters, accounts, transfers (map RFID domain events to ledger operations).
- [ ] **TigerBeetle client**: use official client for your language (likely a small **Rust/Go/Node** worker consuming Kafka → TigerBeetle; Zig is optional here unless you add FFI).
- [ ] **PostgreSQL**: migrations (e.g. `sqlx`/`flyway`); tables for projections, operator queries, or non-ledger data; **outbox** or **exactly-once** strategy coordinated with Kafka consumer groups.
- [ ] **End-to-end idempotency**: consumer stores processed `(topic, partition, offset)` or business keys to avoid duplicate ledger writes.

---

## Phase C — Docker

- [ ] **Dockerfile** for Zig reader service: multi-stage build (Zig build → minimal runtime image with `glibc`, `libxml2`, Zebra `.so` from `linux64_sdk/lib`, `LD_LIBRARY_PATH` set).
- [ ] **Compose stack**: reader (optional profile), Kafka/Redpanda, TigerBeetle, Postgres, consumer worker(s), observability (logs/metrics).
- [ ] **Secrets/config**: reader IP, TLS PEM paths or secrets mount, broker URLs, TB/Postgres DSNs — via env or Docker secrets.

---

## Phase D — Multi-architecture (ARM + x86)

- [ ] **Zig cross-compile** targets: `x86_64-linux-gnu` and `aarch64-linux-gnu`; CI matrix build.
- [ ] **Zebra RFID API3 native libs**: current tree is **linux64** (`librfidapi32.so`). **ARM** requires verifying Zebra provides **linux-arm64** (or equivalent) SDK/libs for the same API; if not available, options are: (a) run reader container **amd64-only** on emulation, (b) use a different integration path on ARM, or (c) restrict production reader hosts to amd64 until SDK parity exists.
- [ ] **`docker buildx`** with `--platform linux/amd64,linux/arm64` where artifacts exist; document **fallback** (single-platform image) if ARM linkage is blocked.

---

## Phase E — Ops & quality

- [ ] Health checks, structured logging, metrics (reads/s, publish lag, consumer lag).
- [ ] Load test: burst tag reads → Kafka → workers without ledger corruption.
- [ ] Runbooks: broker down, TB unavailable, Postgres migration, reader disconnect.

---

## Suggested order of execution

1. Spike: Kafka topic + one consumer writing to Postgres only (prove pipeline).  
2. Add TigerBeetle for the subset of events that need ledger semantics.  
3. Harden Docker + compose; then tackle multi-arch with explicit decision on Zebra ARM SDK.

---

## Related paths in this repo

- Zig app: `apps/rfid-queue-host/zig-rfid-queue/`
- Zebra SDK (canonical): `apps/host-app/linux64_sdk/` (also linked from `apps/rfid-queue-host/linux64_sdk`)
