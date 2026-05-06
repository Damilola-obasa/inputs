#!/usr/bin/env bash
set -euo pipefail

ORG="${1:-$BUILDKITE_ORGANIZATION_SLUG}"
PIPELINE="${2:-$BUILDKITE_PIPELINE_SLUG}"
BUILD="${3:-$BUILDKITE_BUILD_NUMBER}"

PYTHON_SCRIPT=$(mktemp)
trap 'rm -f "$PYTHON_SCRIPT"' EXIT

cat > "$PYTHON_SCRIPT" <<'EOF'
import sys, json
from datetime import datetime

build = json.load(sys.stdin)

print(f"Build #{build['number']} — {build['state']}\n")
print(f"{'Job':<50} {'Wait time':>10}")
print("-" * 62)

for job in build.get("jobs", []):
    name = job.get("name") or job.get("type", "unknown")
    runnable = job.get("runnable_at")
    started = job.get("started_at")

    if runnable and started:
        runnable_dt = datetime.fromisoformat(runnable.replace("Z", "+00:00"))
        started_dt = datetime.fromisoformat(started.replace("Z", "+00:00"))
        wait = (started_dt - runnable_dt).total_seconds()
        print(f"{name:<50} {wait:>9.1f}s")
    else:
        print(f"{name:<50} {'N/A':>10}")
EOF

curl -sf \
  -H "Authorization: Bearer ${BUILDKITE_API_TOKEN:?BUILDKITE_API_TOKEN not set}" \
  "https://api.buildkite.com/v2/organizations/${ORG}/pipelines/${PIPELINE}/builds/${BUILD}" \
  | python3 "$PYTHON_SCRIPT"
