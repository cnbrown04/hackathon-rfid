# Zig RFID queue host (`rfid_queue_host`)

## Where this lives

| Item | Path |
|------|------|
| **Project** | `apps/rfid-queue-host/zig-rfid-queue/` (repo root: `hackathon-rfid`) |
| **Zebra C SDK** | `apps/rfid-queue-host/linux64_sdk/` → symlink to `apps/host-app/linux64_sdk/` (`include/`, `lib/librfidapi32.so`, etc.) |
| **Binary** | After `zig build`: `zig-out/bin/rfid_queue_host` |

This program uses **Zig** plus the **Zebra RFID API3 C SDK** to connect to a fixed reader, register for tag-read events, dequeue `TAG_DATA` from the SDK, and print one **JSON object per line** (stdout). **Each distinct EPC is emitted at most once per wall-clock second** (duplicate reads within the same second are dropped). A later Docker-backed queue can replace the consumer.

## Prerequisites

- **Zig** (e.g. 0.15.x) on `PATH`
- **Linux** x86_64 with the SDK libraries available
- **Packages** (linking): e.g. `libxml2-dev` so `libxml2` resolves at link time; runtime still needs `libxml2` on the system

## Build

```bash
cd apps/rfid-queue-host/zig-rfid-queue
zig build
```

The executable is installed as `zig-out/bin/rfid_queue_host`.

## Run (always set `LD_LIBRARY_PATH`)

```bash
cd apps/rfid-queue-host/zig-rfid-queue
export LD_LIBRARY_PATH="$(pwd)/../linux64_sdk/lib:${LD_LIBRARY_PATH:-}"
```

### Normal LLRP (non-secure, port **5084**)

With **secure LLRP disabled** on the reader, use **two arguments**: reader IP and duration in seconds. The app connects with **`RFID_ConnectA`** on port **5084** (default) and does **not** set `SEC_CONNECTION_INFO` (no TLS).

```bash
zig build run -- 169.254.57.58 30
```

Same thing by running the binary:

```bash
./zig-out/bin/rfid_queue_host 169.254.57.58 30
```

- **One argument** `IP` only: port `5084`, duration **15** seconds.
- **Two arguments** `IP` `seconds`: port `5084`, your duration.
- **Three arguments** `IP` `port` `seconds`: custom port (only if you change the reader port).

Inventory uses **antenna 1** explicitly in code.

### Simulated mode (no reader)

Omit the IP to generate fake tags (for testing the queue/JSON path without hardware):

```bash
zig build run
```

Duration is **15** seconds (default). There is no separate “seconds only” flag without an IP in the current CLI.

### Optional: secure LLRP (TLS + PEM files)

Only if you turn **secure LLRP** back on: pass `secure` (or set `RFID_SECURE=1`) and set paths to PEM material (same idea as Zebra `J_RFIDHostSample1` — `client_crt.pem`, `client_key.pem`, `cacert.pem`, optional passphrase). See env vars `RFID_CLIENT_CERT`, `RFID_CLIENT_KEY`, `RFID_ROOT_CERT`, `RFID_KEY_PASSPHRASE`, `RFID_VALIDATE_PEER` in `src/main.zig`.

## What it prints

### Startup

- Simulated: `No reader IP provided, running in simulated mode for N seconds.`
- Reader: `Connected to reader <ip>:<port>. Collecting tags for N seconds...`

### Tag lines (stdout)

Each tag is one **JSON object per line** (no array wrapper):

```json
{"epc":"300833B2DDD9014000000000","antenna":1,"rssi":-50,"seen_at_ms":1776107854708}
```

| Field | Meaning |
|-------|--------|
| `epc` | EPC bytes from the reader, **hex** (no `0x` prefix) |
| `antenna` | Antenna ID (here forced to antenna **1** in inventory) |
| `rssi` | `peakRSSI` from `TAG_DATA` |
| `seen_at_ms` | Local wall time when the row was queued (milliseconds) |

**Simulated mode** uses a fake repeating EPC pattern and fixed RSSI so you can see the pipeline without tags in the field.

**Live reader** lines look the same; `epc` and `rssi` come from real `TAG_DATA`. You need tags in the field and a successful connection on **5084** with LLRP enabled.

### Errors

Failures from the SDK are printed to stderr with the numeric `RFID_STATUS` and `RFID_GetErrorDescriptionA`. Secure connect failures may also print `SEC_CONNECTION_INFO.connStatus` (OpenSSL hint).

## Notes

- Queue size is bounded (drops oldest on overflow); see `TagQueue` in `src/main.zig`.
- Next step for production: replace or augment `consumerLoop` to publish to your Docker queue service.
