#!/bin/bash

# Simple script to generate a deploy target name
# This is a basic example - you can modify this logic as needed

# Debug all environment variables
echo "Debug: Current directory: $(pwd)" >&2
echo "Debug: BUILDKITE_BRANCH=$BUILDKITE_BRANCH" >&2
echo "Debug: BUILDKITE_PIPELINE_SLUG=$BUILDKITE_PIPELINE_SLUG" >&2
echo "Debug: BUILDKITE_BUILD_NUMBER=$BUILDKITE_BUILD_NUMBER" >&2

# Get current timestamp
TIMESTAMP=$(date +%s)
echo "Debug: TIMESTAMP=$TIMESTAMP" >&2

# Get current branch name (or use 'main' as default)
BRANCH_NAME=${BUILDKITE_BRANCH:-main}
echo "Debug: BRANCH_NAME=$BRANCH_NAME" >&2

# Generate a simple deploy target name
DEPLOY_NAME="pex-${TIMESTAMP}-deploy-${BRANCH_NAME}"
echo "Debug: DEPLOY_NAME=$DEPLOY_NAME" >&2

# Output the result
echo "$DEPLOY_NAME"
