#!/usr/bin/env bash
# Usage: ./job-wait-time.sh <org> <pipeline> <build-number>
# Requires: BUILDKITE_API_TOKEN env var

set -euo pipefail

ORG="${1:?Usage: $0 <org> <pipeline> <build-number>}"
PIPELINE="${2:?}"
BUILD="${3:?}"

response=$(curl -sf \
  -H "Authorization: Bearer ${BUILDKITE_API_TOKEN:?BUILDKITE_API_TOKEN not set}" \
  "https://api.buildkite.com/v2/organizations/${ORG}/pipelines/${PIPELINE}/builds/${BUILD}")

echo "$response" | python3 - <<'EOF'
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
