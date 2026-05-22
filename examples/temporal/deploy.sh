#!/usr/bin/env bash
# Temporal Workflow Engine Deployment — delegates to shared deploy script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../shared/deploy.sh" "$@"
