#!/usr/bin/env bash
# Run this script on your Buildkite agent machine (as the user that runs the agent
# or with sudo) to fix SSH clone issues ("No user exists for uid 501" / known_hosts path).
# This uses a fixed path so the agent never relies on /Users/micheal or UID 501.

set -euo pipefail

# Use a path that doesn't depend on the running user's home
SSH_DIR="${SSH_DIR:-/opt/homebrew/etc/buildkite-agent/ssh}"

echo "Setting up agent SSH in: $SSH_DIR"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# 1. known_hosts so we don't rely on ~/.ssh
echo "Adding github.com to known_hosts..."
ssh-keyscan -t ed25519,rsa github.com 2>/dev/null >> "$SSH_DIR/known_hosts"
sort -u "$SSH_DIR/known_hosts" -o "$SSH_DIR/known_hosts"
chmod 600 "$SSH_DIR/known_hosts"

# 2. Create deploy key if it doesn't exist
KEY_FILE="$SSH_DIR/id_ed25519"
if [[ ! -f "$KEY_FILE" ]]; then
  echo "Creating new SSH key for git clone..."
  ssh-keygen -t ed25519 -C "buildkite-agent" -f "$KEY_FILE" -N ""
  chmod 600 "$KEY_FILE"
  echo ""
  echo "Add this deploy key to GitHub: Repo → Settings → Deploy keys → Add"
  echo "---"
  cat "$KEY_FILE.pub"
  echo "---"
else
  echo "Using existing key: $KEY_FILE"
fi

# 3. Build GIT_SSH_COMMAND that uses this dir (no reference to /Users/micheal)
IDENTITY="-i $KEY_FILE"
GIT_SSH_CMD="ssh -o UserKnownHostsFile=$SSH_DIR/known_hosts -o StrictHostKeyChecking=accept-new $IDENTITY"

echo ""
echo "Add this to your Buildkite agent config so every job uses it:"
echo ""
echo "  environment=\"GIT_SSH_COMMAND=$GIT_SSH_CMD\""
echo ""
echo "Config file (macOS Homebrew): /opt/homebrew/etc/buildkite-agent/buildkite-agent.cfg"
echo "Or create/edit: ~/.buildkite-agent/buildkite-agent.cfg"
echo ""
echo "Then restart the agent:"
echo "  launchctl kickstart -k gui/\$(id -u)/com.buildkite.buildkite-agent"
echo "  # or: brew services restart buildkite-agent"
