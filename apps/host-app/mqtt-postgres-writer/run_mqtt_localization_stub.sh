#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
MQTT_CLIENT_ID="${MQTT_CLIENT_ID:-rfid-localization-stub}"
MQTT_USERNAME="${MQTT_USERNAME:-}"
MQTT_PASSWORD="${MQTT_PASSWORD:-}"

INPUT_TOPIC="${INPUT_TOPIC:-rfid/+/epc/+/features-rolling}"
OUTPUT_ROOT="${OUTPUT_ROOT:-rfid}"

ZONE_THRESHOLD="${ZONE_THRESHOLD:-0.20}"
ZONE_HYSTERESIS="${ZONE_HYSTERESIS:-0.05}"
ZONE_DEBOUNCE_COUNT="${ZONE_DEBOUNCE_COUNT:-3}"
RSSI_DELTA_BIAS_DB="${RSSI_DELTA_BIAS_DB:-0.0}"
MAX_ABS_RSSI_DELTA_DB="${MAX_ABS_RSSI_DELTA_DB:-12.0}"
MIN_TOTAL_READS="${MIN_TOTAL_READS:-12}"
STALE_AGE_MS="${STALE_AGE_MS:-1500}"
SMOOTHING_ALPHA="${SMOOTHING_ALPHA:-0.35}"
IDLE_TTL_MS="${IDLE_TTL_MS:-5000}"

exec python3 "$ROOT/mqtt_localization_stub.py" \
  --mqtt-broker-url "$MQTT_BROKER_URL" \
  --mqtt-client-id "$MQTT_CLIENT_ID" \
  --mqtt-username "$MQTT_USERNAME" \
  --mqtt-password "$MQTT_PASSWORD" \
  --input-topic "$INPUT_TOPIC" \
  --output-root "$OUTPUT_ROOT" \
  --zone-threshold "$ZONE_THRESHOLD" \
  --zone-hysteresis "$ZONE_HYSTERESIS" \
  --zone-debounce-count "$ZONE_DEBOUNCE_COUNT" \
  --rssi-delta-bias-db "$RSSI_DELTA_BIAS_DB" \
  --max-abs-rssi-delta-db "$MAX_ABS_RSSI_DELTA_DB" \
  --min-total-reads "$MIN_TOTAL_READS" \
  --stale-age-ms "$STALE_AGE_MS" \
  --smoothing-alpha "$SMOOTHING_ALPHA" \
  --idle-ttl-ms "$IDLE_TTL_MS"
