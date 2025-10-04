#!/bin/bash
set -euo pipefail

# Load helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/navi-colors.sh"

SCRIPT_NAME="navi"
MAIN_TARGET="/usr/local/bin/$SCRIPT_NAME"
MAIN_SOURCE="./navi"
DEP_TARGET_DIR="/usr/local/share/navi/"


# --- Checks ---
if [[ ! -f "$MAIN_SOURCE" ]]; then
    redLog "Source script '$MAIN_SOURCE' not found!"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    yellowLog "You are not root. Using sudo..."
    SUDO="sudo"
else
    SUDO=""
fi

# --- Install ---
greenLog "Removing $SCRIPT_NAME..."
$SUDO rm -f "$MAIN_TARGET"
$SUDO rm -rf "$DEP_TARGET_DIR"


greenLog "Removed successfully!"
