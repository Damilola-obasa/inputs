#!/bin/bash
set -euo pipefail

# --- User section: set environment variables however you want ---
# Example: set from a file, command, or hardcoded
export MY_DYNAMIC_VAR="hello-world"
export ANOTHER_VAR=$(date +%Y-%m-%d)
# You can add more logic here as needed

# --- Generate the dynamic pipeline YAML ---
cat <<EOF > buildkite/dynamic-pipeline.yml
steps:
  - label: "Dynamic Step"
    command: echo "MY_DYNAMIC_VAR is $MY_DYNAMIC_VAR, ANOTHER_VAR is $ANOTHER_VAR"
    env:
      MY_DYNAMIC_VAR: "$MY_DYNAMIC_VAR"
      ANOTHER_VAR: "$ANOTHER_VAR"
EOF

# --- Upload the generated pipeline ---
buildkite-agent pipeline upload buildkite/dynamic-pipeline.yml 