#!/bin/bash

# Simple script to generate a deploy target name
# This is a basic example - you can modify this logic as needed

# Get current timestamp
TIMESTAMP=$(date +%s)

# Get current branch name (or use 'main' as default)
BRANCH_NAME=${BUILDKITE_BRANCH:-main}
echo "Debug: BUILDKITE_BRANCH=$BUILDKITE_BRANCH" >&2
echo "Debug: BRANCH_NAME=$BRANCH_NAME" >&2

# Generate a simple deploy target name
echo "pex-${TIMESTAMP}-deploy-${BRANCH_NAME}"
