#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --------------------------------------------------------------
# Library
# --------------------------------------------------------------

source $SCRIPT_DIR/_lib.sh

# --------------------------------------------------------------
# General Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/pkgs.sh

# --------------------------------------------------------------
# Distro related packages
# --------------------------------------------------------------

declare -a packages=(
    # Hyprland
    "hyprland"
    "libnotify"
    "qt5-wayland"
    "qt6-wayland"
    "uwsm"
    "python-pip"
    "python-gobject"
    "python-screeninfo"
    "nm-connection-editor"
    "network-manager-applet"
    "imagemagick"
    "polkit-gnome"
    "hyprshade"
    "grimblast-git"
    "pacman-contrib"
    "loupe"
    "power-profiles-daemon"
    # Apps
    "waypaper"
    "swaync"
    # Tools
    "eza"
    "python-pywalfox"
    # Themes
    "papirus-icon-theme"
    "breeze"
    # Fonts
    "otf-font-awesome"
    "ttf-material-icons"
    "ttf-fira-sans"
    "ttf-fira-code"
    "ttf-firacode-nerd"
    "ttf-dejavu"
    "noto-fonts"
    "noto-fonts-emoji"
    "noto-fonts-cjk"
    "noto-fonts-extra"
)

_isInstalled() {
    local package="$1"
    sudo pacman -Qe --color always "${package}" 2>&1 > /dev/null
    echo $?
    return
}

_installYay() {
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
    echo ":: yay has been installed successfully."
}

_installPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo -e "${GREEN}:: ${pkg} is already installed.${NONE}"
            continue
        fi

        echo ":: Installing ${pkg} ..."
        if yay --noconfirm -S "${pkg}" > /dev/null 2>&1; then
            echo -e "${GREEN}:: ${pkg} has been installed successfully.${NONE}"
        else
            echo -e "${RED}:: Error installing ${pkg}.${NONE}"
            errorPackages+=("${pkg}")
        fi
    done
}

_installChaoticRepository(){
    echo ":: Installing [chaotic-aur] repository for a lot of precompiled AUR Packages"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    cat $SCRIPT_DIR/_gdg-arch/chaotic-aur/repository | sudo tee -a /etc/pacman.conf > /dev/null
    echo -e "${GREEN}:: [chaotic-aur] repository is now installed${NONE}"
    echo ":: Syncing the mirrorlist and update the system packages"
    sudo pacman --noconfirm -Syu
}

# --------------------------------------------------------------
# Install Gum
# --------------------------------------------------------------

if [[ $(_checkCommandExists "gum") == 0 ]]; then
    echo ":: gum is already installed"
else
    echo ":: The installer requires gum. gum will be installed now"
    sudo pacman --noconfirm -S gum
fi

# --------------------------------------------------------------
# Header
# --------------------------------------------------------------

_writeHeader "Arch"

# Install chaotic-aur repository for a lot of precompiled AUR Packages
if [[ -f "/etc/pacman.d/chaotic-mirrorlist" ]]; then
    echo -e "${GREEN}:: [chaotic-aur] repository is already installed${NONE}"
else
    _installChaoticRepository
fi
CHAOTIC_AUR_INSTALLED=1

# --------------------------------------------------------------
# Install yay if needed
# --------------------------------------------------------------

if [[ $(_checkCommandExists "yay") == 0 ]]; then
    echo -e "${GREEN}:: yay is already installed${NONE}"
else
    echo ":: The installer requires yay. yay will be installed now"
    if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        sudo pacman --noconfirm -S yay
    else
        _installYay
    fi
fi

# --------------------------------------------------------------
# General
# --------------------------------------------------------------

_installPackages "${general[@]}"

# --------------------------------------------------------------
# Apps
# --------------------------------------------------------------

_installPackages "${apps[@]}"

# --------------------------------------------------------------
# Tools
# --------------------------------------------------------------

_installPackages "${tools[@]}"

# --------------------------------------------------------------
# Packages
# --------------------------------------------------------------

_installPackages "${packages[@]}"

# --------------------------------------------------------------
# Hyprland
# --------------------------------------------------------------

_installPackages "${hyprland[@]}"

# --------------------------------------------------------------
# Create .local/bin folder
# --------------------------------------------------------------

if [ ! -d $HOME/.local/bin ]; then
    mkdir -p $HOME/.local/bin
fi

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        _installPackages "oh-my-posh-bin"
else
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
fi

# --------------------------------------------------------------
# Prebuilt Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/_prebuilt.sh

# --------------------------------------------------------------
# ML4W Apps
# --------------------------------------------------------------

source $SCRIPT_DIR/_ml4w-apps.sh

# --------------------------------------------------------------
# Flatpaks
# --------------------------------------------------------------

source $SCRIPT_DIR/_flatpaks.sh

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        _installPackages "bibata-cursor-theme-bin"
else
    source $SCRIPT_DIR/_cursors.sh
fi

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source $SCRIPT_DIR/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source $SCRIPT_DIR/_icons.sh

# --------------------------------------------------------------
# GDG Custom Packages
# --------------------------------------------------------------

echo -e "${GREEN}"
figlet -p "Additional packages"
echo -e "${NONE}"
echo
if gum confirm "Do you want to install my selection of additional packages?"; then
    source ${SCRIPT_DIR}/_gdg-arch/custom-packages.sh
fi

# --------------------------------------------------------------
# Finish
# --------------------------------------------------------------

_finishMessage
