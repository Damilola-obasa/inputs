# Fix Buildkite agent SSH ("No user exists for uid 501")

If you see:
- `No user exists for uid 501`
- `known_hosts at "/Users/micheal/.ssh/known_hosts"`
- `fatal: Could not read from remote repository`

the agent is using your Mac user’s SSH paths in an environment where that user/UID doesn’t exist. Fix it by giving the agent its own SSH config in a **fixed path** and telling git to use that.

## Steps (on the agent machine)

### 1. Run the setup script

From this repo (or copy the script to the agent):

```bash
# Option A: run from repo
./buildkite/setup-agent-ssh.sh

# Option B: use a custom dir
SSH_DIR=/etc/buildkite-agent/ssh ./buildkite/setup-agent-ssh.sh
```

This will:
- Create `known_hosts` for github.com in a fixed directory
- Create an SSH key for the agent (if none exists)
- Print the exact `environment=` line to add to the agent config

### 2. Add deploy key to GitHub (first time only)

If the script created a new key, it will print a public key. Add it in GitHub:

- Repo → **Settings** → **Deploy keys** → **Add deploy key**
- Paste the key, name it (e.g. "Buildkite agent"), save

### 3. Set agent environment

Edit the Buildkite agent config and add the `environment` line the script printed, for example:

**macOS (Homebrew):** `/opt/homebrew/etc/buildkite-agent/buildkite-agent.cfg`

```ini
# Use fixed-path SSH so we never depend on /Users/micheal or UID 501
environment="GIT_SSH_COMMAND=ssh -o UserKnownHostsFile=/opt/homebrew/etc/buildkite-agent/ssh/known_hosts -o StrictHostKeyChecking=accept-new -i /opt/homebrew/etc/buildkite-agent/ssh/id_ed25519"
```

**Other installs:** `~/.buildkite-agent/buildkite-agent.cfg` or the path shown by the script.

### 4. Restart the agent

```bash
# macOS launchd
launchctl kickstart -k gui/$(id -u)/com.buildkite.buildkite-agent

# Or if you use brew services
brew services restart buildkite-agent
```

After this, `git clone` will use the fixed SSH path and no longer reference `/Users/micheal` or UID 501.
