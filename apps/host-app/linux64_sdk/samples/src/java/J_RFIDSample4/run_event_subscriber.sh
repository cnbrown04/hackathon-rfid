#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SDK="$(cd "$ROOT/../../../../lib" && pwd)"
ENV_FILE="$ROOT/.env"

export LD_LIBRARY_PATH="$SDK"

if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$ENV_FILE"
  set +a
fi

if [ "$#" -gt 0 ]; then
  exec java -cp "$SDK/Symbol.RFID.API3.jar:$SDK/org.eclipse.paho.client.mqttv3-1.2.5.jar:$SDK/postgresql-42.7.4.jar:$ROOT/dist/J_RFIDSample4.jar" \
    rfidsample4.RFIDTourEventSubscriber "$@"
fi

MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
MQTT_TOPIC="${MQTT_TOPIC:-rfid/+/+/+/epc/+/transition}"
PG_URI="${PG_URI:-jdbc:postgresql://127.0.0.1:5432/rfid}"
PG_USER="${PG_USER:-}"
PG_PASSWORD="${PG_PASSWORD:-}"
AUTO_CREATE_TABLE="${AUTO_CREATE_TABLE:-true}"
MQTT_CLIENT_ID="${MQTT_CLIENT_ID:-}"
MQTT_USER="${MQTT_USER:-${MQTT_USERNAME:-}}"
MQTT_PASS="${MQTT_PASS:-${MQTT_PASSWORD:-}}"

exec java -cp "$SDK/Symbol.RFID.API3.jar:$SDK/org.eclipse.paho.client.mqttv3-1.2.5.jar:$SDK/postgresql-42.7.4.jar:$ROOT/dist/J_RFIDSample4.jar" \
  rfidsample4.RFIDTourEventSubscriber \
  "$MQTT_BROKER_URL" \
  "$MQTT_TOPIC" \
  "$PG_URI" \
  "$PG_USER" \
  "$PG_PASSWORD" \
  "$AUTO_CREATE_TABLE" \
  "$MQTT_CLIENT_ID" \
  "$MQTT_USER" \
  "$MQTT_PASS"
