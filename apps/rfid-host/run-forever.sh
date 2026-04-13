#!/usr/bin/env bash
# Run until SIGINT/SIGTERM. Same as: zig build run -- <ip> 0 (optional port as second arg).
#
# Usage: ./run-forever.sh <reader-ip> [port]
# Run from apps/rfid-host so Zig finds .env and linux64_sdk paths match README.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

export LD_LIBRARY_PATH="${ROOT}/linux64_sdk/lib:${LD_LIBRARY_PATH:-}"

EXE="${ROOT}/zig-out/bin/rfid_queue_host"
if [[ ! -x "$EXE" ]]; then
  zig build
fi

case "${1:-}" in
  ""|-h|--help)
    echo "Usage: $(basename "$0") <reader-ip> [port]" >&2
    echo "  Runs until interrupted. Default LLRP port is 5084." >&2
    exit 1
    ;;
esac

if [[ $# -eq 1 ]]; then
  exec "$EXE" "$1" 0
fi
if [[ $# -eq 2 ]]; then
  exec "$EXE" "$1" "$2" 0
fi

echo "Usage: $(basename "$0") <reader-ip> [port]" >&2
exit 1
