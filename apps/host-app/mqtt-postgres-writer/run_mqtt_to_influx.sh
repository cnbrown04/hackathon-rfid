#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

: "${INFLUX_URL:?Set INFLUX_URL}"
: "${INFLUX_TOKEN:?Set INFLUX_TOKEN}"
: "${INFLUX_ORG:?Set INFLUX_ORG}"
: "${INFLUX_BUCKET:?Set INFLUX_BUCKET}"

if command -v curl >/dev/null 2>&1; then
  if ! curl -fsS "$INFLUX_URL/health" >/dev/null 2>&1; then
    echo "InfluxDB is not reachable at $INFLUX_URL" >&2
    echo "Start local Influx first: $ROOT/run_influx_local.sh" >&2
    exit 1
  fi
fi

MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
MQTT_TOPIC="${MQTT_TOPIC:-rfid/+/antenna/+/raw-read}"
MQTT_CLIENT_ID="${MQTT_CLIENT_ID:-rfid-raw-influx-writer}"
MQTT_USERNAME="${MQTT_USERNAME:-}"
MQTT_PASSWORD="${MQTT_PASSWORD:-}"

exec python3 "$ROOT/mqtt_to_influx.py" \
  --mqtt-broker-url "$MQTT_BROKER_URL" \
  --mqtt-topic "$MQTT_TOPIC" \
  --mqtt-client-id "$MQTT_CLIENT_ID" \
  --mqtt-username "$MQTT_USERNAME" \
  --mqtt-password "$MQTT_PASSWORD" \
  --influx-url "$INFLUX_URL" \
  --influx-token "$INFLUX_TOKEN" \
  --influx-org "$INFLUX_ORG" \
  --influx-bucket "$INFLUX_BUCKET"
