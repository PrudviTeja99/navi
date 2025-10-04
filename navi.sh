#!/bin/bash
# Navi - Omarchy-like interactive package manager for CachyOS
# Features: CamelCase fuzzy menus, sudo upfront, interactive/auto-confirm (-y/-n),
# CLI args, fuzzy package search with preview, and sleep inhibition during updates.

set -euo pipefail

# Load helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/navi-ensure-source-installed.sh"
source "$SCRIPT_DIR/navi-colors.sh"

# --- Show help ---
show_help() {
    cat <<EOF
Navi - Interactive Package Manager Wrapper

Usage:
  navi [ACTION] [SOURCE] [OPTIONS]

Actions:
  install     Install packages
  remove      Remove installed packages
  update      Update all packages (pacman, AUR, Flatpak)

Sources:
  pacman      Use pacman for official repo packages
  paru        Use paru for AUR packages

Options:
  -y, --yes     Auto-confirm all prompts (assume "yes")
  -n, --no      Auto-decline all prompts (assume "no")
  --dry-run     Show what would be done without executing
  -h, --help    Show this help message and exit

Examples:
  navi                # Start interactive fuzzy menu
  navi install pacman # Install package(s) from official repos
  navi remove paru    # Remove package(s) installed via AUR
  navi update -y      # Update everything without prompts

Notes:
  * If no ACTION or SOURCE is provided, fuzzy menus will guide you.
  * Package descriptions are shown in preview with Ctrl-P toggle.
  * Updates run under systemd-inhibit to prevent sleep/idle.
EOF
    exit 0
}

# --- Parse help ---
for arg in "$@"; do
    case "$arg" in
        -h|--help) show_help ;;
    esac
done

# --- Sudo upfront & keep alive ---
sudo -v
while true; do sudo -v; sleep 60; done 2>/dev/null &
SUDO_LOOP_PID=$!
trap "kill $SUDO_LOOP_PID" EXIT INT TERM

# --- Check dependencies ---
for cmd in fzf paru pacman; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done
HAS_FLATPAK=false
HAS_PARU=false
command -v flatpak &>/dev/null && HAS_FLATPAK=true
command -v paru &>/dev/null && HAS_PARU=true

# --- Parse options ---
AUTO_CONFIRM="ask" # default interactive
DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        -y|--yes) AUTO_CONFIRM="yes" ;;
        -n|--no)  AUTO_CONFIRM="no" ;;
        --dry-run) DRY_RUN=true ;;
    esac
done

# --- Determine action ---
action_input="${1:-}"

case "$action_input" in
    i) action="install" ;;
    r) action="remove" ;;
    u) action="update" ;;
    install|remove|update) action="$action_input" ;;
    "") 
        action_display=$(printf "Install\nRemove\nSystem Update" | fzf --height=40% --reverse --border --prompt="Select action: " --ansi)
        [[ -z "$action_display" ]] && action_display="Install"
        action=$(echo "$action_display" | tr '[:upper:]' '[:lower:]')
        ;;
    *)
        echo "Unknown action: $action_input"
        exit 1
        ;;
esac
action_display="$(tr '[:lower:]' '[:upper:]' <<< ${action:0:1})${action:1}"


# --- Determine source (skip for update) ---
if [[ "$action" != "update" ]]; then
    source_input="${2:-}"
    case "$source_input" in
        p) source="pacman" ;;
        a) source="paru" ;;
        f) source="flatpak" ;;
        pacman|paru|flatpak) source="$source_input" ;;
        "")
            # Interactive menu
            source_display=$(printf "Pacman\nParu (AUR Helper)\nFlatpak" | fzf --height=20% --reverse --border --prompt="Select source: " --ansi)
            [[ -z "$source_display" ]] && source_display="Pacman"
            source=$(echo "$source_display" | tr '[:upper:]' '[:lower:]')
            ;;
        *)
            echo "Unknown source: $source_input"
            exit 1
            ;;
    esac
    ensure_source_installed "$source"
    source_display="$(tr '[:lower:]' '[:upper:]' <<< ${source:0:1})${source:1}"
fi

run_inhibited() {
    local op="$1"
    local pkgs="$2"
    shift 2
    systemd-inhibit \
        --what=handle-lid-switch:sleep:idle \
        --who="navi script" \
        --why="Package $op: $pkgs" \
        bash -c "$*"
}


# --- Helper for package operations (install/remove) ---
pkg_action() {
    local op="$1"  # install/remove
    local pkgs="$2"

    pkgs=$(echo "$pkgs" | xargs) # trim
    [[ -z "$pkgs" ]] && return

    local yes_cmd=""
    local no_cmd=""

    if [[ "$op" == "install" ]]; then
        case "$source" in
            pacman)
                yes_cmd="sudo pacman -S --noconfirm $pkgs"
                no_cmd="echo n | sudo pacman -S $pkgs"
                ;;
            paru)
                yes_cmd="paru -S --noconfirm $pkgs"
                no_cmd="echo n | paru -S $pkgs"
                ;;
            flatpak)
                yes_cmd="flatpak install -y $pkgs"
                no_cmd="echo n | flatpak install $pkgs"
                ;;

        esac
    else  # remove
        case "$source" in
            pacman) 
                yes_cmd="sudo pacman -Rns --noconfirm $pkgs"
                no_cmd="echo n | sudo pacman -Rns $pkgs"
                ;;
            paru)   
                yes_cmd="paru -Rns --noconfirm $pkgs"
                no_cmd="echo n | paru -Rns $pkgs"
                ;;
            flatpak)
                yes_cmd="flatpak uninstall --delete-data -y $pkgs"
                no_cmd="echo n | flatpak uninstall $pkgs"
                ;;

        esac
    fi

    set +e
    # Apply confirm / dry-run logic
    if [[ "$AUTO_CONFIRM" == "yes" ]]; then
        run_inhibited "$op" "$pkgs" "$yes_cmd"
        greenLog "Done $op : $pkgs"
    elif [[ "$AUTO_CONFIRM" == "no" ]]; then
        run_inhibited "$op" "$pkgs" "$no_cmd"
        yellowLog "Skipping $op: $pkgs"
    else
        read -rp "$op $pkgs? [y/N]: " ans < /dev/tty
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            run_inhibited "$op" "$pkgs" "$yes_cmd"
            greenLog "Done $op : $pkgs"
        else
            run_inhibited "$op" "$pkgs" "$no_cmd"
            yellowLog "Skipping $op: $pkgs"
        fi
    fi
    set -e
}

update_all() {

    greenLog "--- Updating Pacman Packages ---"
    $pacman_cmd

    if $HAS_PARU; then
        greenLog "--- Updating AUR Packages ---"
        $paru_cmd
    fi

    if $HAS_FLATPAK; then
        greenLog "--- Updating Flatpak Packages ---"
        $flatpak_cmd
    fi

    greenLog "All updates completed"

}

# --- Update packages ---
update_packages() {
    set +e
    pacman_updates=$(checkupdates 2>/dev/null | awk '{print $1}')
    aur_updates=$(paru -Qua 2>/dev/null | sed 's/^ *//' | sed 's/ \+/ /g' | grep -vw "\[ignored\]$" | awk '{print $1}')
    flatpak_updates=""
    $HAS_FLATPAK && flatpak_updates=$(flatpak update | sed -n '/^ 1./,$p' | awk '{print $2}' | grep -v '^$' | sed '$d')
    set -e

    # Combine for preview
    updates_preview=""
    [[ -n "$pacman_updates" ]] && updates_preview+="\n${GREEN}--- Pacman Updates ---${RESET}\n$pacman_updates"
    [[ -n "$aur_updates" ]] && updates_preview+="\n${GREEN}--- AUR Updates ---${RESET}\n$aur_updates"
    [[ -n "$flatpak_updates" ]] && updates_preview+="\n${GREEN}--- Flatpak Updates ---${RESET}\n$flatpak_updates"

    if [[ -z "$updates_preview" ]]; then
        greenLog "All packages are up-to-date"
        return
    fi

    # Show preview
    echo -e "$updates_preview"

    # Ask user to proceed if AUTO_CONFIRM=ask
    if [[ "$AUTO_CONFIRM" == "ask" ]]; then
        read -rp $'\nProceed with updating all packages? [y/N]: ' ans < /dev/tty
        [[ ! "$ans" =~ ^[Yy]$ ]] && { echo -e "${YELLOW}Skipping all updates.${RESET}"; return; }
    elif [[ "$AUTO_CONFIRM" == "no" ]]; then
        yellowLog "Skipping all updates"; return;
    fi

    yellowLog "Updating packages (sleep/idle inhibited)..."
    pacman_cmd="sudo pacman -Syu --noconfirm"
    paru_cmd="paru -Sua --noconfirm"
    flatpak_cmd="flatpak update -y"

    export pacman_cmd paru_cmd flatpak_cmd

    export GREEN YELLOW RED RESET

    run_inhibited "update" "all" "$(declare -f update_all); update_all"
    
}

# --- Run update directly ---
if [[ "$action" == "update" ]]; then
    update_packages
    exit 0
fi

# --- Build package list ---
if [[ "$action" == "remove" ]]; then
    case "$source" in
        pacman) pkg_list=$(pacman -Qq) ;;
        paru)   pkg_list=$(paru -Qq) ;;
        flatpak) pkg_list=$(flatpak list --app --columns=application) ;;
    esac
else
    case "$source" in
        pacman) pkg_list=$(pacman -Slq) ;;
        paru)   pkg_list=$(paru -Slq) ;;
        flatpak) pkg_list=$(flatpak search --columns=application "") ;;  # simple search for all
    esac
fi

# --- Fuzzy select packages ---
pkg=$(echo "$pkg_list" | fzf \
    --multi \
    --height=100% \
    --layout=reverse \
    --border \
    --prompt="[$source_display] $action_display: " \
    --preview "if [[ '$source' == 'pacman' ]]; then
              pacman -Si {};
          elif [[ '$source' == 'paru' ]]; then
              paru -Si {};
          else
            flatpak info {} 2>/dev/null || flatpak remote-info flathub {}
          fi" \
    --bind "ctrl-p:toggle-preview"
)

[[ -z "$pkg" ]] && { echo "No package selected."; exit 0; }

selected_pkgs=$(echo "$pkg" | tr '\n' ' ')

# --- Perform selected action ---
pkg_action "$action" "$selected_pkgs"
