#!/usr/bin/env bash
# Temporal Stack Cleanup — delegates to shared cleanup script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../shared/cleanup.sh" "$@"
