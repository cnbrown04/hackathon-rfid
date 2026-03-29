#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SDK="$(cd "$ROOT/../../../../lib" && pwd)"
CFG="${1:-$ROOT/raw-read-publisher.properties}"
OUT="$ROOT/out"

export LD_LIBRARY_PATH="$SDK"
mkdir -p "$OUT"

javac -cp "$SDK/Symbol.RFID.API3.jar:$SDK/org.eclipse.paho.client.mqttv3-1.2.5.jar" \
  -d "$OUT" \
  "$ROOT/src/rfidsample4/RFIDRawReadPublisher.java"

exec java -cp "$SDK/Symbol.RFID.API3.jar:$SDK/org.eclipse.paho.client.mqttv3-1.2.5.jar:$OUT" \
  rfidsample4.RFIDRawReadPublisher --config "$CFG"
