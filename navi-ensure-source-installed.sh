#!/bin/bash
# navi-ensure-source-installed - extra helper functions for Navi script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/navi-colors.sh"

# --- Ensure optional sources are installed ---
ensure_source_installed() {
    local src="$1"

    case "$src" in
        paru)
            if ! command -v paru &>/dev/null; then
                echo -e "${YELLOW}Paru not found. Installing via pacman...${RESET}"
                sudo pacman -S --noconfirm paru
                echo -e "${GREEN}Paru installed successfully.${RESET}"
                HAS_PARU=true
            fi
            ;;
        flatpak)
            if ! command -v flatpak &>/dev/null; then
                echo -e "${YELLOW}Flatpak not found. Installing via pacman...${RESET}"
                sudo pacman -S --noconfirm flatpak
                echo -e "${GREEN}Flatpak installed successfully.${RESET}"
                HAS_FLATPAK=true
            fi
            ;;
    esac
}

