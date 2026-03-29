#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
HOST_APP_ROOT="$(cd "$ROOT/.." && pwd)"

PYTHON_BIN="${PYTHON_BIN:-python3}"
MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"

RAW_PUBLISHER_SCRIPT="${RAW_PUBLISHER_SCRIPT:-$HOST_APP_ROOT/linux64_sdk/samples/src/java/J_RFIDSample4/run_raw_read_publisher.sh}"
RAW_PUBLISHER_TEMPLATE="${RAW_PUBLISHER_TEMPLATE:-$HOST_APP_ROOT/linux64_sdk/samples/src/java/J_RFIDSample4/raw-read-publisher.properties}"

CALIBRATION_CSV_PATH="${CALIBRATION_CSV_PATH:-$ROOT/calibration.csv}"
EPC_PREFIX="${EPC_PREFIX:-E280699500005001FAD}"
FINGERPRINT_JSON_PATH="${FINGERPRINT_JSON_PATH:-$ROOT/calibration_fingerprint.json}"

RESULTS_CSV="${RESULTS_CSV:-$ROOT/tuning_results.csv}"
BEST_ENV="${BEST_ENV:-$ROOT/best_config.env}"
LOGS_DIR="${LOGS_DIR:-$ROOT/logs/tuning}"

mkdir -p "$LOGS_DIR"

exec "$PYTHON_BIN" "$ROOT/tune_calibrated_coarse_to_fine.py" \
  --mqtt-broker-url "$MQTT_BROKER_URL" \
  --raw-publisher-script "$RAW_PUBLISHER_SCRIPT" \
  --raw-publisher-template "$RAW_PUBLISHER_TEMPLATE" \
  --run-feature-script "$ROOT/run_mqtt_feature_rolling.sh" \
  --run-calibrated-script "$ROOT/run_mqtt_localization_calibrated.sh" \
  --evaluator-script "$ROOT/mqtt_calibrated_evaluator.py" \
  --python-bin "$PYTHON_BIN" \
  --calibration-csv-path "$CALIBRATION_CSV_PATH" \
  --epc-prefix "$EPC_PREFIX" \
  --fingerprint-json-path "$FINGERPRINT_JSON_PATH" \
  --feature-topic "rfid/+/antenna/+/raw-read" \
  --output-root "rfid" \
  --calibrated-topic "rfid/+/epc/+/localization-calibrated" \
  --collect-duration-sec "${COLLECT_DURATION_SEC:-45}" \
  --eval-duration-sec "${EVAL_DURATION_SEC:-45}" \
  --collect-min-samples "${COLLECT_MIN_SAMPLES:-20}" \
  --max-abs-rssi-delta-db "${MAX_ABS_RSSI_DELTA_DB:-12.0}" \
  --idle-ttl-ms "${IDLE_TTL_MS:-5000}" \
  --antenna-spacing-ft "${ANTENNA_SPACING_FT:-10.0}" \
  --y-line-x-ft "${Y_LINE_X_FT:-0.0}" \
  --mismatch-penalty-ft "${MISMATCH_PENALTY_FT:-5.0}" \
  --coarse-tx-powers "${COARSE_TX_POWERS:-80,60,40}" \
  --coarse-w-rssi "${COARSE_W_RSSI:-0.8,1.0,1.2}" \
  --coarse-w-score "${COARSE_W_SCORE:-0.5,0.8,1.0}" \
  --coarse-min-samples "${COARSE_MIN_SAMPLES:-8,10,14}" \
  --coarse-switch-hysteresis "${COARSE_SWITCH_HYSTERESIS:-0.05,0.08,0.12}" \
  --coarse-debounce "${COARSE_DEBOUNCE:-2,3}" \
  --coarse-smoothing "${COARSE_SMOOTHING:-0.25,0.35,0.5}" \
  --results-csv "$RESULTS_CSV" \
  --best-env "$BEST_ENV" \
  --logs-dir "$LOGS_DIR"
