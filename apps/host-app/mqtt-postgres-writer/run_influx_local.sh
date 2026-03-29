#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$ROOT/.env.influx"

if [ ! -f "$ENV_FILE" ]; then
  cp "$ROOT/.env.influx.example" "$ENV_FILE"
  echo "Created $ENV_FILE from example. Update values if needed."
fi

docker compose -f "$ROOT/docker-compose.influx.yml" --env-file "$ENV_FILE" up -d

echo "Waiting for InfluxDB health endpoint..."
for _ in $(seq 1 30); do
  if curl -fsS "http://127.0.0.1:8086/health" >/dev/null 2>&1; then
    echo "InfluxDB is healthy at http://127.0.0.1:8086"
    break
  fi
  sleep 1
done

if ! curl -fsS "http://127.0.0.1:8086/health" >/dev/null 2>&1; then
  echo "InfluxDB did not become healthy in time." >&2
  exit 1
fi

echo
echo "Export these for the collector:"
echo "export INFLUX_URL=http://127.0.0.1:8086"
echo "export INFLUX_TOKEN=$(grep '^INFLUXDB_INIT_ADMIN_TOKEN=' "$ENV_FILE" | cut -d= -f2-)"
echo "export INFLUX_ORG=$(grep '^INFLUXDB_INIT_ORG=' "$ENV_FILE" | cut -d= -f2-)"
echo "export INFLUX_BUCKET=$(grep '^INFLUXDB_INIT_BUCKET=' "$ENV_FILE" | cut -d= -f2-)"
