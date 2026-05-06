#!/bin/bash
set -euo pipefail

# Load helper functions
DEP_DIR="/usr/local/share/navi"
if [[ -d "$DEP_DIR" && -f "$DEP_DIR/navi-colors.sh" ]]; then
    source "$DEP_DIR/navi-colors.sh"
elif [[ -f "./navi-colors.sh" ]]; then
    source "./navi-colors.sh"
else
    # Fallback if colors script isn't found
    greenLog() { echo -e "\e[32m$1\e[0m"; }
    yellowLog() { echo -e "\e[33m$1\e[0m"; }
fi

SCRIPT_NAME="navi"
MAIN_TARGET="/usr/local/bin/$SCRIPT_NAME"
DEP_TARGET_DIR="/usr/local/share/navi/"

if [[ $EUID -ne 0 ]]; then
    yellowLog "You are not root. Using sudo..."
    SUDO="sudo"
else
    SUDO=""
fi

greenLog "Removing $SCRIPT_NAME from system..."

if [[ -f "$MAIN_TARGET" ]]; then
    $SUDO rm -v "$MAIN_TARGET"
fi

if [[ -d "$DEP_TARGET_DIR" ]]; then
    $SUDO rm -rv "$DEP_TARGET_DIR"
fi

# Optional: clean up cache
read -rp "Do you want to remove the package cache in ~/.cache/navi? [y/N]: " clean_cache
if [[ "$clean_cache" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.cache/navi"
    greenLog "Cache cleared."
fi

greenLog "Uninstalled successfully!"
