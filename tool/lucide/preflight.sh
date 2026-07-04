#!/bin/bash

set -e

missing=0

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    missing=1
  fi
}

need dart
need curl
need unzip
need bc
need xmlstarlet
need jq
need fontforge

if [[ "${NORMALIZE_SVG:-0}" == "1" ]]; then
  need inkscape
fi

python_ok=0
for candidate in "${PYTHON:-}" python3 python; do
  if [[ -z "$candidate" ]]; then
    continue
  fi

  if command -v "$candidate" >/dev/null 2>&1 && "$candidate" - <<'PY' >/dev/null 2>&1; then
import fontTools.ttLib
PY
    python_ok=1
    break
  fi
done

if [[ "$python_ok" == "0" ]]; then
  echo "Missing required Python package: fontTools"
  missing=1
fi

if [[ "$missing" != "0" ]]; then
  echo "Install the missing dependencies before running gen.sh; assets were not changed."
  exit 1
fi
