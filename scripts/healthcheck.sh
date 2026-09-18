#!/bin/sh
set -eu

URL="${1:-http://localhost:8080/}"

echo "Checking health of: $URL"

if command -v curl >/dev/null 2>&1; then
  if curl -s -f "$URL" >/dev/null; then
    echo "Healthcheck passed: Service is responding."
    exit 0
  else
    echo "Healthcheck failed: Service returned non-200 status or is unreachable."
    exit 1
  fi
else
  echo "curl is not installed."
  exit 1
fi