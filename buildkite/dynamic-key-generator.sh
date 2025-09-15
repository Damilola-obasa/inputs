#!/bin/bash

TIMESTAMP=$(date +%s)
RANDOM_SUFFIX=$((RANDOM % 10000))

echo "dynamic-key-${TIMESTAMP}-${RANDOM_SUFFIX}"
