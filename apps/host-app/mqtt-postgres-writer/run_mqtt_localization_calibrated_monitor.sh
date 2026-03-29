#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
MQTT_CLIENT_ID="${MQTT_CLIENT_ID:-rfid-calibrated-monitor}"
MQTT_USERNAME="${MQTT_USERNAME:-}"
MQTT_PASSWORD="${MQTT_PASSWORD:-}"
TOPIC="${TOPIC:-rfid/+/epc/+/localization-calibrated}"

exec python3 "$ROOT/mqtt_localization_calibrated_monitor.py" \
  --mqtt-broker-url "$MQTT_BROKER_URL" \
  --mqtt-client-id "$MQTT_CLIENT_ID" \
  --mqtt-username "$MQTT_USERNAME" \
  --mqtt-password "$MQTT_PASSWORD" \
  --topic "$TOPIC"
