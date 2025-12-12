#!/bin/bash
set -euo pipefail

echo "=== Job Concurrency Information ==="
echo ""
echo "Job Type: ${JOB_TYPE:-not set}"
echo "Build Creator: ${BUILDKITE_BUILD_CREATOR:-not set}"
echo "Build Number: ${BUILDKITE_BUILD_NUMBER:-not set}"
echo "Concurrency Group: runner/${BUILDKITE_BUILD_CREATOR:-unknown}/${JOB_TYPE:-unknown}"
echo ""
echo "=== Concurrency Configuration by Job Type ==="
echo ""

CONFIG_FILE="buildkite/concurrency-config.json"

if [ -f "$CONFIG_FILE" ]; then
  jq -r 'to_entries[] | "\(.key): \(.value) concurrent jobs"' "$CONFIG_FILE"
else
  echo "Error: Config file $CONFIG_FILE not found"
  exit 1
fi

echo ""
echo "=== Current Job Concurrency Limit ==="
LIMIT=$(jq -r --arg type "${JOB_TYPE:-}" '.[$type] // .default' "$CONFIG_FILE")
echo "This job (${JOB_TYPE:-default}) can run ${LIMIT} concurrent instances per user"
echo ""
echo "Job execution starting..."
