#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
SDK="$(cd "$ROOT/../linux64_sdk" && pwd)"
OUT="$ROOT/out"
mkdir -p "$OUT"
export LD_LIBRARY_PATH="$SDK/lib"
javac -cp "$SDK/lib/Symbol.RFID.API3.jar" -d "$OUT" "$ROOT/src/PrefilterRead.java"
exec java -cp "$OUT:$SDK/lib/Symbol.RFID.API3.jar" PrefilterRead "$@"
