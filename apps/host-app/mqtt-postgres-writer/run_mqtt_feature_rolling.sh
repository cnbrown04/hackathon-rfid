#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
MQTT_CLIENT_ID="${MQTT_CLIENT_ID:-rfid-feature-rolling}"
MQTT_USERNAME="${MQTT_USERNAME:-}"
MQTT_PASSWORD="${MQTT_PASSWORD:-}"

INPUT_TOPIC="${INPUT_TOPIC:-rfid/+/antenna/+/raw-read}"
OUTPUT_ROOT="${OUTPUT_ROOT:-rfid}"

WINDOW_MS="${WINDOW_MS:-1000}"
EMIT_EVERY_MS="${EMIT_EVERY_MS:-250}"
IDLE_TTL_MS="${IDLE_TTL_MS:-5000}"

exec python3 "$ROOT/mqtt_feature_rolling.py" \
  --mqtt-broker-url "$MQTT_BROKER_URL" \
  --mqtt-client-id "$MQTT_CLIENT_ID" \
  --mqtt-username "$MQTT_USERNAME" \
  --mqtt-password "$MQTT_PASSWORD" \
  --input-topic "$INPUT_TOPIC" \
  --output-root "$OUTPUT_ROOT" \
  --window-ms "$WINDOW_MS" \
  --emit-every-ms "$EMIT_EVERY_MS" \
  --idle-ttl-ms "$IDLE_TTL_MS"
