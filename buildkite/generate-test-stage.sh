#!/bin/bash

mkdir -p .buildkite/deploy_test

cat <<EOF > .buildkite/deploy_test/test.yml
steps:
  - label: "🚀 Deploy Stage (Recreated)"
    key: "deploy-stage-\${BUILDKITE_BUILD_NUMBER}"
    command: |
      echo "This is the recreated step with the same key!"
      echo "Build: \${BUILDKITE_BUILD_NUMBER}"
      echo "Retry count: \${BUILDKITE_RETRY_COUNT}"
      echo "✅ Recreated step completed successfully"
    retry:
      automatic:
        - exit_status: "*"
          limit: 2
EOF

echo "Generated test.yml pipeline file"
