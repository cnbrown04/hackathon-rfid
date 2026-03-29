# MQTT to Influx Collector

## Start local InfluxDB (Docker)

```bash
./run_influx_local.sh
```

- This creates `.env.influx` from `.env.influx.example` on first run.
- Default retention is `2h` for demo use.
- Influx is exposed on `http://127.0.0.1:8086`.

## Install

```bash
python3 -m pip install -r requirements.txt
```

## Run

```bash
export INFLUX_URL="http://127.0.0.1:8086"
export INFLUX_TOKEN="your-token"
export INFLUX_ORG="your-org"
export INFLUX_BUCKET="rfid-demo"

export MQTT_BROKER_URL="tcp://127.0.0.1:1883"
export MQTT_TOPIC="rfid/+/antenna/+/raw-read"

./preflight.sh
./run_mqtt_to_influx.sh
```

The collector validates and writes points into measurement `rfid_raw_reads` using single-point writes.

## Rolling feature publisher (MQTT only)

Publishes derived rolling-window features from raw reads to:

- `rfid/<reader_id>/epc/<epc>/features-rolling`

Run in a separate terminal:

```bash
export MQTT_BROKER_URL="tcp://127.0.0.1:1883"
export INPUT_TOPIC="rfid/+/antenna/+/raw-read"
export OUTPUT_ROOT="rfid"
export WINDOW_MS=1000
export EMIT_EVERY_MS=250
export IDLE_TTL_MS=5000

./run_mqtt_feature_rolling.sh
```

## Localization stub (phase 3, MQTT only)

Consumes rolling features and publishes lightweight zone/confidence estimates to:

- `rfid/<reader_id>/epc/<epc>/localization-stub`

Run in another terminal:

```bash
export MQTT_BROKER_URL="tcp://127.0.0.1:1883"
export INPUT_TOPIC="rfid/+/epc/+/features-rolling"
export OUTPUT_ROOT="rfid"

export ZONE_THRESHOLD=0.20
export ZONE_HYSTERESIS=0.05
export ZONE_DEBOUNCE_COUNT=3
export RSSI_DELTA_BIAS_DB=0.0
export MAX_ABS_RSSI_DELTA_DB=12.0
export MIN_TOTAL_READS=12
export STALE_AGE_MS=1500
export SMOOTHING_ALPHA=0.35
export IDLE_TTL_MS=5000

./run_mqtt_localization_stub.sh
```

Output payload fields include:

- `stub_version`, `estimator`, `ts_emit_ms`, `reader_id`, `epc`
- `zone_label`, `zone_candidate`, `zone_score`, `confidence`
- `both_antennas_present`, `count_ant1`, `count_ant2`
- `rssi_delta_ant1_minus_ant2`, `rssi_delta_corrected_ant1_minus_ant2`, `phase_delta_ant1_minus_ant2`, `age_ms_ant1`, `age_ms_ant2`

Tuning notes:

- Increase `ZONE_DEBOUNCE_COUNT` to reduce label flicker.
- Increase `ZONE_HYSTERESIS` to make transitions less sensitive near threshold.
- Adjust `RSSI_DELTA_BIAS_DB` to re-center `BETWEEN` for physical antenna asymmetry.

## Deterministic calibration localizer (phase 3b, no ML)

Consumes rolling features and publishes calibrated estimates to:

- `rfid/<reader_id>/epc/<epc>/localization-calibrated`

### One-time (or refresh) calibration fingerprint collection

Use known calibration tags in `calibration.csv` to build `calibration_fingerprint.json`.

```bash
export MODE="collect-fingerprint"
export MQTT_BROKER_URL="tcp://127.0.0.1:1883"
export INPUT_TOPIC="rfid/+/epc/+/features-rolling"
export CALIBRATION_CSV_PATH="./calibration.csv"
export EPC_PREFIX="E280699500005001FAD"
export FINGERPRINT_JSON_PATH="./calibration_fingerprint.json"
export COLLECT_MIN_SAMPLES=20

./run_mqtt_localization_calibrated.sh
```

Stop with Ctrl+C after enough reads. The fingerprint JSON is written on shutdown.

### Runtime calibrated estimation

```bash
export MODE="estimate"
export MQTT_BROKER_URL="tcp://127.0.0.1:1883"
export INPUT_TOPIC="rfid/+/epc/+/features-rolling"
export OUTPUT_ROOT="rfid"

export CALIBRATION_CSV_PATH="./calibration.csv"
export EPC_PREFIX="E280699500005001FAD"
export FINGERPRINT_JSON_PATH="./calibration_fingerprint.json"

export USE_PHASE=false
export W_RSSI=1.0
export W_PHASE=0.0
export W_SCORE=0.8
export MAX_ABS_RSSI_DELTA_DB=12.0

export MIN_SAMPLES=10
export SWITCH_HYSTERESIS=0.08
export ESTIMATE_DEBOUNCE_COUNT=3
export ESTIMATE_SMOOTHING_ALPHA=0.35
export IDLE_TTL_MS=5000

# Coordinate frame:
# - (0,0) at antenna 2
# - y increases antenna 2 -> antenna 1
export ANTENNA_SPACING_FT=10.0
export Y_LINE_X_FT=0.0

./run_mqtt_localization_calibrated.sh
```

Output includes:

- `line_est`, `distance_est_ft`, `confidence`
- `global_est.x_ft`, `global_est.y_ft`
- `top_matches`, `current_signature`, `weights`, `quality`

### Calibrated estimate monitor

```bash
./run_mqtt_localization_calibrated_monitor.sh
```

## One-command demo launcher

After calibration fingerprint exists at `./calibration_fingerprint.json`, run:

```bash
./run_demo_mode.sh
```

If `./best_config.env` exists, `run_demo_mode.sh` auto-loads it (including tuned `TX_POWER_INDEX`).

This launches:

- raw publisher
- rolling feature service
- calibrated localizer (estimate mode)
- calibrated monitor

Logs are written to `./logs/demo/`.

## Coarse-to-fine tuning (distance-priority, holdout test tags)

Your `calibration.csv` supports `test=true/false` rows:

- `test=false` rows are used for fingerprint training.
- `test=true` rows are held out for evaluation.

Run the tuner:

```bash
./run_tune_calibrated_coarse_to_fine.sh
```

Important: test tags (`test=true`) must be physically present and readable during evaluation windows.
If no held-out test rows are observed, tuning aborts early with guidance.

Outputs:

- `tuning_results.csv` (all configs and metrics)
- `best_config.env` (best config by score)
- `logs/tuning/` (per-run logs + evaluator outputs)

Primary optimization objective is distance accuracy:

- `score = 0.70*distance_mae_ft + 0.20*distance_p90_error_ft + 0.10*(1-line_accuracy)`

Optional overrides for faster/slower sweeps:

```bash
COARSE_TX_POWERS="80,60" EVAL_DURATION_SEC=30 COLLECT_DURATION_SEC=30 ./run_tune_calibrated_coarse_to_fine.sh
```

Use tuned settings in calibrated estimate mode:

```bash
set -a
source ./best_config.env
set +a

export MODE="estimate"
./run_mqtt_localization_calibrated.sh
```

## Run order for demo

1. Build/install Python deps once: `python3 -m pip install -r requirements.txt`
2. Start MQTT broker on `tcp://127.0.0.1:1883`
3. (Optional storage) `./run_influx_local.sh`
4. (Optional storage) `./preflight.sh`
5. (Optional storage) `./run_mqtt_to_influx.sh`
6. Start raw publisher: `../linux64_sdk/samples/src/java/J_RFIDSample4/run_raw_read_publisher.sh`
7. Start feature publisher: `./run_mqtt_feature_rolling.sh`
8. Start calibrated localizer estimate mode: `./run_mqtt_localization_calibrated.sh`
9. Start monitor: `./run_mqtt_localization_calibrated_monitor.sh`

Shortcut:

- `./run_demo_mode.sh`

Optional monitors:

- Feature monitor: `python3 mqtt_feature_monitor.py`
- Stub monitor: `./run_mqtt_localization_monitor.sh`
