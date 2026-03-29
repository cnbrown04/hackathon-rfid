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

## Run order for demo

1. `./run_influx_local.sh`
2. `./preflight.sh`
3. `./run_mqtt_to_influx.sh`
4. `../linux64_sdk/samples/src/java/J_RFIDSample4/run_raw_read_publisher.sh`
5. `./run_mqtt_feature_rolling.sh`
6. `./run_mqtt_localization_stub.sh`
