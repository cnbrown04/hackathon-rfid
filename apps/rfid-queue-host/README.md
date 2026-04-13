# RFID queue host (Zig)

This directory holds the **Zig RFID reader client** and a **symlink** to the shared Zebra **linux64** C SDK used elsewhere under `apps/host-app/`.

| Path | Role |
|------|------|
| `zig-rfid-queue/` | Zig app (`rfid_queue_host`), build with `zig build` |
| `linux64_sdk` | Symlink → `../host-app/linux64_sdk` (headers + `librfidapi32.so`, etc.) |

See **`ROADMAP.md`** for the planned Kafka / TigerBeetle / Postgres / Docker / multi-arch work (not implemented yet).
