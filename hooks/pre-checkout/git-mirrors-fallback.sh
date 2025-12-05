#!/bin/bash
set -euo pipefail

echo "--- :git: Pre-checkout hook: Verifying git mirrors"

GIT_MIRRORS_PATH="/var/lib/buildkite-agent/git-mirrors"

# Check if git mirrors directory exists and is writable
if [[ ! -d "$GIT_MIRRORS_PATH" ]] || [[ ! -w "$GIT_MIRRORS_PATH" ]]; then
  echo "⚠️ Mirror mount not available, disabling git mirrors"
  unset BUILDKITE_REPO_MIRROR
  unset BUILDKITE_GIT_MIRRORS_PATH
else
  echo "✅ Git mirrors available at: $GIT_MIRRORS_PATH"
fi

echo "--- :white_check_mark: Pre-checkout hook complete"
