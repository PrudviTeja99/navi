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
                yellowLog "Paru not found. Checking if available in pacman..."

                # Check if paru is available in official repos
                if pacman -Si paru &>/dev/null; then
                    yellowLog "Installing paru via pacman..."
                    sudo pacman -S --noconfirm paru
                else
                    yellowLog "Paru not found in pacman repos. Installing from AUR..."

                    # Ensure git and base-devel are installed
                    if ! command -v git &>/dev/null; then
                        yellowLog "Git not found. Installing via pacman..."
                        sudo pacman -S --needed --noconfirm git
                    fi

                    if ! pacman -Qi base-devel &>/dev/null; then
                        yellowLog "Base-devel not found. Installing via pacman..."
                        sudo pacman -S --needed --noconfirm base-devel
                    fi

                    # Clone and build paru from AUR
                    tmpdir=$(mktemp -d)
                    git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
                    cd "$tmpdir/paru" || exit 1
                    makepkg -si --noconfirm

                    cd - >/dev/null || true
                    rm -rf "$tmpdir"
                fi

                greenLog "Paru installed successfully."
                HAS_PARU=true
            fi
            ;;
        flatpak)
            if ! command -v flatpak &>/dev/null; then
                yellowLog "Flatpak not found. Installing via pacman..."
                sudo pacman -S --noconfirm flatpak
                greenLog "Flatpak installed successfully."
                HAS_FLATPAK=true
            fi
            ;;
    esac
}

