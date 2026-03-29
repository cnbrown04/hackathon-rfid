#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
CFG_WELCOME="${1:-$ROOT/tour-publisher-welcome.properties}"
CFG_LIDAR="${2:-$ROOT/tour-publisher-lidar.properties}"

if [[ ! -f "$CFG_WELCOME" ]]; then
  echo "Missing config file: $CFG_WELCOME" >&2
  exit 1
fi

if [[ ! -f "$CFG_LIDAR" ]]; then
  echo "Missing config file: $CFG_LIDAR" >&2
  exit 1
fi

cleanup() {
  kill "$PID_WELCOME" "$PID_LIDAR" 2>/dev/null || true
  wait "$PID_WELCOME" "$PID_LIDAR" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

"$ROOT/run_tour_publisher.sh" "$CFG_WELCOME" &
PID_WELCOME=$!

"$ROOT/run_tour_publisher.sh" "$CFG_LIDAR" &
PID_LIDAR=$!

echo "Started welcome PID=$PID_WELCOME with $CFG_WELCOME"
echo "Started lidar PID=$PID_LIDAR with $CFG_LIDAR"

wait "$PID_WELCOME" "$PID_LIDAR"
