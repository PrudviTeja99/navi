
fetch_all_packages(){
    fetch_installed_packages
    fetch_remote_packages
}

#Fetch installed packges
fetch_installed_packages(){
    pacman -Qq > /tmp/navi_pacman_installed &
    PACMAN_INSTALLED_PID=$!

    paru -Qq > /tmp/navi_aur_installed &
    AUR_INSTALLED_PID=$!
    flatpak list --app --columns=application > /tmp/navi_flatpak_installed &
    FLATPAK_INSTALLED_PID=$!
}


#Fetch from remote
fetch_remote_packages(){
    pacman -Slq > /tmp/navi_pacman_remote &
    PACMAN_REMOTE_PID=$!

    paru -Slq > /tmp/navi_aur_remote &
    AUR_REMOTE_PID=$!

    flatpak search --columns=application "" > /tmp/navi_flatpak_remote &
    FLATPAK_REMOTE_PID=$!
}
