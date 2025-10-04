#!/bin/bash
# navi-common.sh - shared colors and message helpers for Navi scripts

# --- Colors ---
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# --- Message functions ---
greenLog()  { echo -e "${GREEN}$*${RESET}"; }
yellowLog()  { echo -e "${YELLOW}$*${RESET}"; }
redLog() { echo -e "${RED}$*${RESET}"; }