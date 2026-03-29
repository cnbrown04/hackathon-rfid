#!/usr/bin/env bash
# Run both tour aggregators and the MQTT→Postgres event writer, with prefixed logs.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
HOST_APP="$REPO_ROOT/apps/host-app/linux64_sdk/samples/src/java/J_RFIDSample4"

PIDS=()

cleanup() {
  local pid
  for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
  wait 2>/dev/null || true
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

run_prefixed() {
  local label="$1"
  shift
  "$@" > >(sed -l "s|^|[$label] |") 2>&1 &
  PIDS+=($!)
}

run_prefixed "aggregator-1" "$HOST_APP/run_tour_aggregator.sh" "$HOST_APP/tour-aggregator.properties"
run_prefixed "aggregator-2" "$HOST_APP/run_tour_aggregator.sh" "$HOST_APP/tour-aggregator-reader-2.properties"
run_prefixed "event-writer" "$HOST_APP/run_event_writer.sh"

wait
