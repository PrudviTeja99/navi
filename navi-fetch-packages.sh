
fetch_all_packages(){
    fetch_installed_packages
    fetch_remote_packages
}

#Fetch installed packges
fetch_installed_packages(){
    pacman -Qq > "$PACMAN_INSTALLED_TMP" &
    PACMAN_INSTALLED_PID=$!

    paru -Qq > "$AUR_INSTALLED_TMP" &
    AUR_INSTALLED_PID=$!
    flatpak list --app --columns=application > "$FLATPAK_INSTALLED_TMP" &
    FLATPAK_INSTALLED_PID=$!
}


#Fetch from remote
fetch_remote_packages(){
    pacman -Slq > "$PACMAN_REMOTE_TMP" &
    PACMAN_REMOTE_PID=$!

    paru -Slq > "$AUR_REMOTE_TMP" &
    AUR_REMOTE_PID=$!

    flatpak search --columns=application "" > "$FLATPAK_REMOTE_TMP" &
    FLATPAK_REMOTE_PID=$!
}
