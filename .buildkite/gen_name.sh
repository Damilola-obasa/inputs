#!/bin/bash

# Simple script to generate a deploy target name
# This is a basic example - you can modify this logic as needed

# Get current timestamp
TIMESTAMP=$(date +%s)

# Get current branch name (or use 'main' as default)
BRANCH_NAME=${BUILDKITE_BRANCH:-main}

# Generate a simple deploy target name
echo "pex-${TIMESTAMP}-deploy-${BRANCH_NAME}"
