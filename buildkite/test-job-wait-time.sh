#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

PYTHON_SCRIPT=$(mktemp)
trap 'rm -f "$PYTHON_SCRIPT"' EXIT

cat > "$PYTHON_SCRIPT" <<'EOF'
import sys, json
from datetime import datetime

build = json.load(sys.stdin)

for job in build.get("jobs", []):
    name = job.get("name") or job.get("type", "unknown")
    runnable = job.get("runnable_at")
    started = job.get("started_at")

    if runnable and started:
        runnable_dt = datetime.fromisoformat(runnable.replace("Z", "+00:00"))
        started_dt = datetime.fromisoformat(started.replace("Z", "+00:00"))
        wait = (started_dt - runnable_dt).total_seconds()
        print(f"{wait:.1f}")
    else:
        print("N/A")
EOF

run_test() {
  local name="$1"
  local input="$2"
  local expected="$3"

  actual=$(echo "$input" | python3 "$PYTHON_SCRIPT")

  if [ "$actual" = "$expected" ]; then
    echo "PASS: $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $name — expected '$expected', got '$actual'"
    FAIL=$((FAIL + 1))
  fi
}

# 10 second wait
run_test "10s agent wait" \
  '{"number":1,"state":"passed","jobs":[{"name":"my-job","runnable_at":"2024-01-01T00:00:00Z","started_at":"2024-01-01T00:00:10Z"}]}' \
  "10.0"

# 0 second wait (instant pickup)
run_test "instant pickup" \
  '{"number":2,"state":"passed","jobs":[{"name":"my-job","runnable_at":"2024-01-01T00:00:00Z","started_at":"2024-01-01T00:00:00Z"}]}' \
  "0.0"

# missing runnable_at falls back to N/A
run_test "missing runnable_at" \
  '{"number":3,"state":"passed","jobs":[{"name":"my-job","started_at":"2024-01-01T00:00:10Z"}]}' \
  "N/A"

# job not yet started
run_test "job not yet started" \
  '{"number":4,"state":"running","jobs":[{"name":"my-job","runnable_at":"2024-01-01T00:00:00Z"}]}' \
  "N/A"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
