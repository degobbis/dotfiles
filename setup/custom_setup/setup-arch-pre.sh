#!/usr/bin/env bash

declare -a errorPackages
declare -a pkgsToInstall

# --------------------------------------------------------------
# Colors
# --------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
NONE='\033[0m'

# --------------------------------------------------------------
# Check if command exists
# --------------------------------------------------------------

_checkCommandExists() {
    local cmd="$1"
    command -v "$cmd" >/dev/null
    echo $?
    return
}

# --------------------------------------------------------------
# Write finish message
# --------------------------------------------------------------

_finishMessage() {
    if [[ ${#errorPackages[@]} -gt 0 ]]; then
        echo -e "${RED}"
        figlet -p "Errors"
        echo ":: Installation finished with errors."
        echo
        echo "The following packages had errors during installation:"
        echo -e "${NONE}"
        echo "${errorPackages[@]}"
        echo

        if gum confirm "DO YOU WANT TO TRY AGAIN THE INSTALLATION OF THIS PACKEGES WITHOUT AUTOCONFIRMATION?: "; then
            pkgsToInstall=("${errorPackages[@]}")
            errorPackages=()
            echo
            echo ":: Installation started."
            echo
            _installErrorPackagesAgain
            _finishMessage
        else
            echo ":: Then please install manually."
        fi
    else
        echo -e "${GREEN}"
        figlet -p "No errors"
        echo ":: Installation completed without errors."
        echo -e "${NONE}"

        echo
        echo
        echo ":: Ready to install the dotfiles with the Dotfiles Installer."
    fi
}

# --------------------------------------------------------------
# Header
# --------------------------------------------------------------

_writeHeader() {
    local distro=$1
    clear
    echo -e "${GREEN}"
cat <<"EOF"
   ____    __
  / __/__ / /___ _____
 _\ \/ -_) __/ // / _ \
/___/\__/__/\_,_/ .__/
                /_/
EOF
    echo "ML4W Dotfiles for Hyprland for $distro"
    echo -e "${NONE}"
    echo "This setup script will install all required packages and dependencies for the dotfiles."
    echo
    if gum confirm "DO YOU WANT TO START THE SETUP NOW?: "; then
        echo ":: Installation started."
        echo
    else
        echo ":: Installation canceled"
        exit
    fi
}

_isInstalled() {
    local package="$1"
    pacman -Q "${package}" 2>&1 > /dev/null
    echo $?
    return
}

_isInstalledFlatpak() {
    local pkg="$1"
    flatpak list --app | grep "${pkg}" 2>&1 > /dev/null
    echo $?
    return
}

_installYay() {
    if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        sudo pacman --noconfirm -S yay
    else
        if [[ ! $(_isInstalled "base-devel") == 0 ]]; then
            sudo pacman --noconfirm -S "base-devel"
        fi
        if [[ ! $(_isInstalled "git") == 0 ]]; then
            sudo pacman --noconfirm -S "git"
        fi
        if [ -d $HOME/Downloads/yay ]; then
            rm -rf $HOME/Downloads/yay
        fi
        local SCRIPT=$(realpath "$0")
        local temp_path=$(dirname "$SCRIPT")
        git clone https://aur.archlinux.org/yay-bin.git $HOME/Downloads/yay
        cd $HOME/Downloads/yay
        makepkg -si
        cd $temp_path
    fi
    echo ":: yay has been installed successfully."
}

_installParu() {
    if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        sudo pacman --noconfirm -S paru
    else
        if [[ ! $(_isInstalled "base-devel") == 0 ]]; then
            sudo pacman --noconfirm -S "base-devel"
        fi
        if [[ ! $(_isInstalled "git") == 0 ]]; then
            sudo pacman --noconfirm -S "git"
        fi
        if [ -d $HOME/Downloads/paru-bin ]; then
            rm -rf $HOME/Downloads/paru-bin
        fi
        SCRIPT=$(realpath "$0")
        temp_path=$(dirname "$SCRIPT")
        git clone https://aur.archlinux.org/paru-bin.git $HOME/Downloads/paru-bin
        cd $HOME/Downloads/paru-bin
        makepkg -si
        cd $temp_path
    fi
    echo ":: paru has been installed successfully."
}

_installAllPackages() {
    $aur_helper --noconfirm -S "${pkgsToInstall[@]}"

    for pkg in "${pkgsToInstall[@]}"; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo -e "${GREEN}:: ${pkg} is already installed.${NONE}"
            continue
        fi

        errorPackages+=("${pkg}")
    done

    pkgsToInstall=()
}

_installErrorPackagesAgain() {
    $aur_helper -S "${pkgsToInstall[@]}"

    for pkg in "${pkgsToInstall[@]}"; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo -e "${GREEN}:: ${pkg} is already installed.${NONE}"
            continue
        fi

        errorPackages+=("${pkg}")
    done

    pkgsToInstall=()
}

_installPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo -e "${GREEN}:: ${pkg} is already installed.${NONE}"
            continue
        fi
        echo ":: Add ${pkg} to install-list"
        pkgsToInstall+=("${pkg}")
    done
}

_installChaoticRepository(){
    echo ":: Installing [chaotic-aur] repository for a lot of precompiled AUR Packages"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --disable-download-timeout 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --disable-download-timeout 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    cat $SCRIPT_DIR/_gdg-arch/chaotic-aur/repository | sudo tee -a /etc/pacman.conf > /dev/null
    echo -e "${GREEN}:: [chaotic-aur] repository is now installed${NONE}"
    echo ":: Syncing the mirrorlist and update the system packages"
    sudo pacman --noconfirm -Syu
}

_selectAURHelper() {
    echo ":: Please select your preferred AUR Helper"
    echo
    aur_helper=$(gum choose "yay" "paru")
    if [ -z ${aur_helper} ]; then
        _selectAURHelper
    fi
    if [[ ! $(_isInstalled "${aur_helper}") == 0 ]]; then
        if [[ ${aur_helper} == "yay" ]]; then
            _installYay
        else
            _installParu
        fi
    fi
    echo ":: Using $aur_helper as AUR Helper"
}

# Install chaotic-aur repository for a lot of precompiled AUR Packages
if [[ -f "/etc/pacman.d/chaotic-mirrorlist" ]]; then
    echo -e "${GREEN}:: [chaotic-aur] repository is already installed${NONE}"
else
    _installChaoticRepository
fi
CHAOTIC_AUR_INSTALLED=1

_selectAURHelper
_installPackages "figlet"

echo
echo -e "${GREEN}:: Prepare packages list to install ...${NONE}"
