#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

# Default MQTT settings can be overridden by env
MQTT_BROKER_URL="${MQTT_BROKER_URL:-tcp://127.0.0.1:1883}"
MQTT_TOPIC="${MQTT_TOPIC:-rfid/+/antenna/+/raw-read}"

# Required Influx settings
: "${INFLUX_URL:?Set INFLUX_URL}"
: "${INFLUX_TOKEN:?Set INFLUX_TOKEN}"
: "${INFLUX_ORG:?Set INFLUX_ORG}"
: "${INFLUX_BUCKET:?Set INFLUX_BUCKET}"

if [ "$INFLUX_TOKEN" = "..." ] || [ "$INFLUX_TOKEN" = "your-token" ]; then
  echo "INFLUX_TOKEN looks like a placeholder; set a real token." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required for preflight checks." >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required for preflight checks." >&2
  exit 1
fi

echo "[1/5] Influx health check at $INFLUX_URL/health"
curl -fsS "$INFLUX_URL/health" >/dev/null

echo "[2/5] Influx auth check with provided token/org"
curl -fsS -H "Authorization: Token $INFLUX_TOKEN" \
  "$INFLUX_URL/api/v2/buckets?org=$INFLUX_ORG" >/dev/null

echo "[3/5] Influx bucket existence check: $INFLUX_BUCKET"
python3 - "$INFLUX_URL" "$INFLUX_TOKEN" "$INFLUX_ORG" "$INFLUX_BUCKET" <<'PY'
import json
import sys
from urllib.request import Request, urlopen

url, token, org, bucket = sys.argv[1:5]
req = Request(
    f"{url}/api/v2/buckets?org={org}",
    headers={"Authorization": f"Token {token}"},
)
with urlopen(req, timeout=10) as resp:
    payload = json.loads(resp.read().decode("utf-8"))

names = {b.get("name", "") for b in payload.get("buckets", [])}
if bucket not in names:
    print(f"Bucket '{bucket}' not found in org '{org}'", file=sys.stderr)
    sys.exit(1)
PY

echo "[4/5] MQTT broker tcp reachability: $MQTT_BROKER_URL"
python3 - "$MQTT_BROKER_URL" <<'PY'
import socket
import sys
from urllib.parse import urlparse

url = sys.argv[1]
parsed = urlparse(url)
if parsed.scheme not in ("tcp", "mqtt"):
    print("MQTT_BROKER_URL must start with tcp:// or mqtt://", file=sys.stderr)
    sys.exit(1)
if not parsed.hostname:
    print("MQTT_BROKER_URL missing host", file=sys.stderr)
    sys.exit(1)
port = parsed.port or 1883
sock = socket.create_connection((parsed.hostname, port), timeout=5)
sock.close()
PY

echo "[5/5] Python dependency import check"
python3 - <<'PY'
import paho.mqtt.client  # noqa: F401
import influxdb_client  # noqa: F401
PY

cat <<EOF
Preflight checks passed.

Ready to run:
  $ROOT/run_mqtt_to_influx.sh

Using:
  INFLUX_URL=$INFLUX_URL
  INFLUX_ORG=$INFLUX_ORG
  INFLUX_BUCKET=$INFLUX_BUCKET
  MQTT_BROKER_URL=$MQTT_BROKER_URL
  MQTT_TOPIC=$MQTT_TOPIC
EOF
