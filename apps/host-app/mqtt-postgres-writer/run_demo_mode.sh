#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
HOST_APP_ROOT="$(cd "$ROOT/.." && pwd)"
RAW_PUBLISHER_SCRIPT="$HOST_APP_ROOT/linux64_sdk/samples/src/java/J_RFIDSample4/run_raw_read_publisher.sh"
RAW_PUBLISHER_TEMPLATE="${RAW_PUBLISHER_TEMPLATE:-$HOST_APP_ROOT/linux64_sdk/samples/src/java/J_RFIDSample4/raw-read-publisher.properties}"

if [ ! -x "$RAW_PUBLISHER_SCRIPT" ]; then
  echo "Raw publisher script not found or not executable: $RAW_PUBLISHER_SCRIPT" >&2
  exit 1
fi

if [ ! -f "$RAW_PUBLISHER_TEMPLATE" ]; then
  echo "Raw publisher template not found: $RAW_PUBLISHER_TEMPLATE" >&2
  exit 1
fi

if [ ! -f "$ROOT/calibration_fingerprint.json" ]; then
  echo "Missing calibration fingerprint: $ROOT/calibration_fingerprint.json" >&2
  echo "Run calibration collection first with MODE=collect-fingerprint." >&2
  exit 1
fi

PYTHON_BIN="$ROOT/.venv/bin/python3"
if [ ! -x "$PYTHON_BIN" ]; then
  PYTHON_BIN="$(command -v python3 || true)"
fi
if [ -z "$PYTHON_BIN" ]; then
  echo "python3 not found. Install python3 or create .venv." >&2
  exit 1
fi

LOG_DIR="${LOG_DIR:-$ROOT/logs/demo}"
mkdir -p "$LOG_DIR"

BEST_ENV_FILE="${BEST_ENV_FILE:-$ROOT/best_config.env}"
if [ -f "$BEST_ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$BEST_ENV_FILE"
  set +a
  echo "Loaded tuned settings from $BEST_ENV_FILE"
fi

MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
INPUT_TOPIC_RAW="${INPUT_TOPIC_RAW:-rfid/+/antenna/+/raw-read}"
INPUT_TOPIC_FEATURES="${INPUT_TOPIC_FEATURES:-rfid/+/epc/+/features-rolling}"
OUTPUT_ROOT="${OUTPUT_ROOT:-rfid}"

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
TX_POWER_INDEX="${TX_POWER_INDEX:-}"

WINDOW_MS="${WINDOW_MS:-1000}"
EMIT_EVERY_MS="${EMIT_EVERY_MS:-250}"

CALIBRATION_CSV_PATH="${CALIBRATION_CSV_PATH:-$ROOT/calibration.csv}"
EPC_PREFIX="${EPC_PREFIX:-E280699500005001FAD}"
FINGERPRINT_JSON_PATH="${FINGERPRINT_JSON_PATH:-$ROOT/calibration_fingerprint.json}"

export MQTT_BROKER_URL OUTPUT_ROOT IDLE_TTL_MS

cleanup() {
  echo
  echo "Stopping demo services..."
  for pid in "${PIDS[@]:-}"; do
    if kill -0 "$pid" >/dev/null 2>&1; then
      kill "$pid" >/dev/null 2>&1 || true
    fi
  done
  if [ -n "${RAW_CFG_PATH:-}" ] && [ -f "$RAW_CFG_PATH" ]; then
    rm -f "$RAW_CFG_PATH" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT INT TERM

PIDS=()

RAW_CFG_PATH=""
if [ -n "$TX_POWER_INDEX" ]; then
  RAW_CFG_PATH="$(mktemp)"
  python3 - "$RAW_PUBLISHER_TEMPLATE" "$RAW_CFG_PATH" "$TX_POWER_INDEX" <<'PY'
import sys

template_path, out_path, power = sys.argv[1:4]

with open(template_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

out = []
seen1 = False
seen2 = False
for line in lines:
    if line.startswith("antenna.txPowerIndex.1="):
        out.append("antenna.txPowerIndex.1={}\n".format(power))
        seen1 = True
        continue
    if line.startswith("antenna.txPowerIndex.2="):
        out.append("antenna.txPowerIndex.2={}\n".format(power))
        seen2 = True
        continue
    out.append(line)

if not seen1:
    out.append("antenna.txPowerIndex.1={}\n".format(power))
if not seen2:
    out.append("antenna.txPowerIndex.2={}\n".format(power))

with open(out_path, "w", encoding="utf-8") as f:
    f.writelines(out)
PY
  echo "Using TX power index override: $TX_POWER_INDEX"
fi

echo "Starting raw publisher..."
if [ -n "$RAW_CFG_PATH" ]; then
  "$RAW_PUBLISHER_SCRIPT" "$RAW_CFG_PATH" >"$LOG_DIR/raw_publisher.log" 2>&1 &
else
  "$RAW_PUBLISHER_SCRIPT" >"$LOG_DIR/raw_publisher.log" 2>&1 &
fi
PIDS+=("$!")

echo "Starting rolling feature service..."
MQTT_BROKER_URL="$MQTT_BROKER_URL" \
INPUT_TOPIC="$INPUT_TOPIC_RAW" \
OUTPUT_ROOT="$OUTPUT_ROOT" \
WINDOW_MS="$WINDOW_MS" \
EMIT_EVERY_MS="$EMIT_EVERY_MS" \
IDLE_TTL_MS="$IDLE_TTL_MS" \
"$ROOT/run_mqtt_feature_rolling.sh" >"$LOG_DIR/feature_rolling.log" 2>&1 &
PIDS+=("$!")

echo "Starting calibrated localizer (estimate mode)..."
MODE="estimate" \
MQTT_BROKER_URL="$MQTT_BROKER_URL" \
INPUT_TOPIC="$INPUT_TOPIC_FEATURES" \
OUTPUT_ROOT="$OUTPUT_ROOT" \
CALIBRATION_CSV_PATH="$CALIBRATION_CSV_PATH" \
EPC_PREFIX="$EPC_PREFIX" \
FINGERPRINT_JSON_PATH="$FINGERPRINT_JSON_PATH" \
USE_PHASE="$USE_PHASE" \
W_RSSI="$W_RSSI" \
W_PHASE="$W_PHASE" \
W_SCORE="$W_SCORE" \
MAX_ABS_RSSI_DELTA_DB="$MAX_ABS_RSSI_DELTA_DB" \
MIN_SAMPLES="$MIN_SAMPLES" \
SWITCH_HYSTERESIS="$SWITCH_HYSTERESIS" \
ESTIMATE_DEBOUNCE_COUNT="$ESTIMATE_DEBOUNCE_COUNT" \
ESTIMATE_SMOOTHING_ALPHA="$ESTIMATE_SMOOTHING_ALPHA" \
IDLE_TTL_MS="$IDLE_TTL_MS" \
ANTENNA_SPACING_FT="$ANTENNA_SPACING_FT" \
Y_LINE_X_FT="$Y_LINE_X_FT" \
"$ROOT/run_mqtt_localization_calibrated.sh" >"$LOG_DIR/localization_calibrated.log" 2>&1 &
PIDS+=("$!")

echo "Starting calibrated monitor..."
MQTT_BROKER_URL="$MQTT_BROKER_URL" \
"$ROOT/run_mqtt_localization_calibrated_monitor.sh" >"$LOG_DIR/localization_monitor.log" 2>&1 &
PIDS+=("$!")

echo
echo "Demo mode started. Logs: $LOG_DIR"
echo "  raw publisher:            $LOG_DIR/raw_publisher.log"
echo "  feature rolling:          $LOG_DIR/feature_rolling.log"
echo "  localization calibrated:  $LOG_DIR/localization_calibrated.log"
echo "  localization monitor:     $LOG_DIR/localization_monitor.log"
echo
echo "Tail live estimate output with:"
echo "  tail -f \"$LOG_DIR/localization_monitor.log\""
echo
echo "Press Ctrl+C to stop all demo services."

wait
