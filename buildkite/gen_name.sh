#!/bin/bash
TIMESTAMP=$(date +%s 2>/dev/null || echo "1234567890")
echo "deploy-${TIMESTAMP}"
