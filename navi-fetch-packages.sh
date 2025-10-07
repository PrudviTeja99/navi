
fetch_all_packages(){
    fetch_installed_packages
    fetch_remote_packages
}

#Fetch installed packges
fetch_installed_packages(){
    fetch_pacman_installed_packages
    fetch_aur_installed_packages
    fetch_flatpak_installed_packages


}


#Fetch from remote
fetch_remote_packages(){
    fetch_pacman_remote_packages
    fetch_aur_remote_packages
    fetch_flatpak_remote_packages
}



fetch_pacman_installed_packages(){
    $PACMAN_QUERY_CMD > "$PACMAN_INSTALLED_TMP" &
    PACMAN_INSTALLED_PID=$!
}
fetch_aur_installed_packages(){
    $AUR_QUERY_CMD > "$AUR_INSTALLED_TMP" &
    AUR_INSTALLED_PID=$!
}
fetch_flatpak_installed_packages(){
    $FLATPAK_QUERY_CMD > "$FLATPAK_INSTALLED_TMP" &
    FLATPAK_INSTALLED_PID=$!
}


fetch_pacman_remote_packages(){
    $PACMAN_REMOTE_CMD > "$PACMAN_REMOTE_TMP" &
    PACMAN_REMOTE_PID=$!
}
fetch_aur_remote_packages(){
    $AUR_REMOTE_CMD > "$AUR_REMOTE_TMP" &
    AUR_REMOTE_PID=$!
}
fetch_flatpak_remote_packages(){
    $FLATPAK_REMOTE_CMD > "$FLATPAK_REMOTE_TMP" &
    FLATPAK_REMOTE_PID=$!
}