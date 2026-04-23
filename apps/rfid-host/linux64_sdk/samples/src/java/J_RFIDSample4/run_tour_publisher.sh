#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SDK="$(cd "$ROOT/../../../../lib" && pwd)"
CFG="${1:-$ROOT/tour-publisher-localize.properties}"

export LD_LIBRARY_PATH="$SDK"

exec java -cp "$SDK/Symbol.RFID.API3.jar:$SDK/org.eclipse.paho.client.mqttv3-1.2.5.jar:$ROOT/dist/J_RFIDSample4.jar" \
  rfidsample4.RFIDTourPublisher --config "$CFG"
