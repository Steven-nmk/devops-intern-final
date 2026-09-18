#!/bin/sh
set -euo pipefail

TARGET_URL="${1:-http://localhost:8080}"

echo "Checking health of: $TARGET_URL"

if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required but not installed." >&2
    exit 1
fi

STATUS_CODE=$(curl -s -o /dev/null -w "\%{http_code}" "$TARGET_URL")

if [ "$STATUS_CODE" -eq 200 ]; then
    echo "Healthcheck passed: Endpoint returned HTTP $STATUS_CODE."
    exit 0
else
    echo "Healthcheck failed: Endpoint returned HTTP $STATUS_CODE." >&2
    exit 1
fi
