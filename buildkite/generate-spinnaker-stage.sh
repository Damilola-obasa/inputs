#!/bin/bash

echo "🔧 Generating spinnaker stage..."

# Create the .buildkite/deploy_manager directory if it doesn't exist
mkdir -p .buildkite/deploy_manager

# Generate the spinnaker-ci pipeline with the SAME key
cat <<EOF > .buildkite/deploy_manager/spinnaker-ci.yml
steps:
  - label: "🚀 Spinnaker Deploy"
    key: "validate_spinnaker_applications"
    command: |
      echo "This is the recreated spinnaker stage with the same key!"
      echo "Build: \${BUILDKITE_BUILD_NUMBER}"
      echo "Retry count: \${BUILDKITE_RETRY_COUNT}"
      echo "✅ Spinnaker stage completed successfully"
    retry:
      automatic:
        - exit_status: "*"
          limit: 2
EOF

echo "📋 Generated spinnaker-ci.yml pipeline with duplicate key"
echo "🚀 Uploading spinnaker stage..."

# Upload the generated pipeline - this will cause the duplicate key error
buildkite-agent pipeline upload .buildkite/deploy_manager/spinnaker-ci.yml

echo "✅ Spinnaker stage uploaded successfully!"
