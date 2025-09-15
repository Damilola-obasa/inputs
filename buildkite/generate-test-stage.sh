#!/bin/bash

mkdir -p .buildkite/deploy_test

cat <<EOF > .buildkite/deploy_test/test.yml
steps:
  - label: "🧪 Test Stage"
    key: "test-stage-\${BUILDKITE_BUILD_NUMBER}"
    command: |
      echo "Generated test stage"
      echo "Build: \${BUILDKITE_BUILD_NUMBER}"
EOF

buildkite-agent pipeline upload .buildkite/deploy_test/test.yml
