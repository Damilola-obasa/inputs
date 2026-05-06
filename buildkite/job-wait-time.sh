#!/usr/bin/env bash
set -euo pipefail

curl -sf \
  -H "Authorization: Bearer ${BUILDKITE_API_TOKEN:?}" \
  "https://api.buildkite.com/v2/organizations/${BUILDKITE_ORGANIZATION_SLUG}/pipelines/${BUILDKITE_PIPELINE_SLUG}/builds/${BUILDKITE_BUILD_NUMBER}" \
  | python3 -c "
import sys, json
from datetime import datetime

for job in json.load(sys.stdin).get('jobs', []):
    runnable = job.get('runnable_at')
    started = job.get('started_at')
    if runnable and started:
        wait = (datetime.fromisoformat(started.replace('Z', '+00:00')) - datetime.fromisoformat(runnable.replace('Z', '+00:00'))).total_seconds()
        print(f\"{job.get('name', 'unknown')}: {wait:.1f}s\")
"
