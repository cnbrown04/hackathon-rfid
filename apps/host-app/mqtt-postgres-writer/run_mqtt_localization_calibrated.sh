#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

MODE="${MODE:-estimate}"

MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
MQTT_CLIENT_ID="${MQTT_CLIENT_ID:-rfid-localization-calibrated}"
MQTT_USERNAME="${MQTT_USERNAME:-}"
MQTT_PASSWORD="${MQTT_PASSWORD:-}"

INPUT_TOPIC="${INPUT_TOPIC:-rfid/+/epc/+/features-rolling}"
OUTPUT_ROOT="${OUTPUT_ROOT:-rfid}"

CALIBRATION_CSV_PATH="${CALIBRATION_CSV_PATH:-$ROOT/calibration.csv}"
EPC_PREFIX="${EPC_PREFIX:-E280699500005001FAD}"
FINGERPRINT_JSON_PATH="${FINGERPRINT_JSON_PATH:-$ROOT/calibration_fingerprint.json}"

FEATURE_WINDOW_MS="${FEATURE_WINDOW_MS:-1000}"
COLLECT_MIN_SAMPLES="${COLLECT_MIN_SAMPLES:-20}"

USE_PHASE="${USE_PHASE:-false}"
W_RSSI="${W_RSSI:-1.0}"
W_PHASE="${W_PHASE:-0.0}"
W_SCORE="${W_SCORE:-0.8}"
MAX_ABS_RSSI_DELTA_DB="${MAX_ABS_RSSI_DELTA_DB:-12.0}"

MIN_SAMPLES="${MIN_SAMPLES:-10}"
SWITCH_HYSTERESIS="${SWITCH_HYSTERESIS:-0.08}"
ESTIMATE_DEBOUNCE_COUNT="${ESTIMATE_DEBOUNCE_COUNT:-3}"
ESTIMATE_SMOOTHING_ALPHA="${ESTIMATE_SMOOTHING_ALPHA:-0.35}"
IDLE_TTL_MS="${IDLE_TTL_MS:-5000}"

ANTENNA_SPACING_FT="${ANTENNA_SPACING_FT:-10.0}"
Y_LINE_X_FT="${Y_LINE_X_FT:-0.0}"

PHASE_FLAG=()
if [ "$USE_PHASE" = "true" ] || [ "$USE_PHASE" = "1" ] || [ "$USE_PHASE" = "yes" ]; then
  PHASE_FLAG+=(--use-phase)
fi

exec python3 "$ROOT/mqtt_localization_calibrated.py" \
  --mode "$MODE" \
  --mqtt-broker-url "$MQTT_BROKER_URL" \
  --mqtt-client-id "$MQTT_CLIENT_ID" \
  --mqtt-username "$MQTT_USERNAME" \
  --mqtt-password "$MQTT_PASSWORD" \
  --input-topic "$INPUT_TOPIC" \
  --output-root "$OUTPUT_ROOT" \
  --calibration-csv-path "$CALIBRATION_CSV_PATH" \
  --epc-prefix "$EPC_PREFIX" \
  --fingerprint-json-path "$FINGERPRINT_JSON_PATH" \
  --feature-window-ms "$FEATURE_WINDOW_MS" \
  --collect-min-samples "$COLLECT_MIN_SAMPLES" \
  "${PHASE_FLAG[@]}" \
  --w-rssi "$W_RSSI" \
  --w-phase "$W_PHASE" \
  --w-score "$W_SCORE" \
  --max-abs-rssi-delta-db "$MAX_ABS_RSSI_DELTA_DB" \
  --min-samples "$MIN_SAMPLES" \
  --switch-hysteresis "$SWITCH_HYSTERESIS" \
  --estimate-debounce-count "$ESTIMATE_DEBOUNCE_COUNT" \
  --estimate-smoothing-alpha "$ESTIMATE_SMOOTHING_ALPHA" \
  --idle-ttl-ms "$IDLE_TTL_MS" \
  --antenna-spacing-ft "$ANTENNA_SPACING_FT" \
  --y-line-x-ft "$Y_LINE_X_FT"
