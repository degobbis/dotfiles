#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

declare -a errorPackages

packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
    "git"
    "figlet"
    "xdg-user-dirs"
    "hyprland"
    "hyprpaper"
    "hyprlock"
    "hypridle"
    "hyprpicker"
    "noto-fonts"
    "noto-fonts-emoji"
    "noto-fonts-cjk"
    "noto-fonts-extra"
    "xdg-desktop-portal-hyprland"
    "libnotify"
    "kitty"
    "qt5-wayland"
    "qt6-wayland"
    "uwsm"
    "fastfetch"
    "xdg-desktop-portal-gtk"
    "eza"
    "nautilus"
    "python-pip"
    "python-gobject"
    "python-screeninfo"
    "tumbler"
    "brightnessctl"
    "nm-connection-editor"
    "network-manager-applet"
    "gtk4"
    "libadwaita"
    "fuse2"
    "imagemagick"
    "jq"
    "xclip"
    "kitty"
    "neovim"
    "htop"
    "blueman"
    "grim"
    "slurp"
    "cliphist"
    "nwg-look"
    "qt6ct"
    "waybar"
    "rofi-wayland"
    "polkit-gnome"
    "zsh"
    "fzf"
    "pavucontrol"
    "papirus-icon-theme"
    "breeze"
    "flatpak"
    "swaync"
    "gvfs"
    "wlogout"
    "hyprshade"
    "waypaper"
    "grimblast-git"
    "bibata-cursor-theme-bin"
    "pacseek"
    "otf-font-awesome"
    "ttf-fira-sans"
    "ttf-fira-code"
    "ttf-firacode-nerd"
    "ttf-dejavu"
    "nwg-dock-hyprland"
    "checkupdates-with-aur"
    "loupe"
    "power-profiles-daemon"
    "python-pywalfox"
    "vlc"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
NONE='\033[0m'

_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

_isInstalled() {
    package="$1"
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
    if [ -d $HOME/Downloads/yay-bin ]; then
        rm -rf $HOME/Downloads/yay-bin
    fi
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay-bin.git $HOME/Downloads/yay-bin
    cd $HOME/Downloads/yay-bin
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
    cat $SCRIPT_DIR/arch/chaotic-aur/repository | sudo tee -a /etc/pacman.conf > /dev/null
    echo -e "${GREEN}:: [chaotic-aur] repository is now installed${NONE}"
    echo ":: Syncing the mirrorlist and update the system packages"
    sudo pacman --noconfirm -Syu
}

# Header
echo -e "${GREEN}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF
echo "ML4W Dotfiles for Hyprland"
echo -e "${NONE}"
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            echo ":: Installation started."
            echo
            break
            ;;
        [Nn]*)
            echo ":: Installation canceled"
            exit
            break
            ;;
        *)
            echo ":: Please answer yes or no."
            ;;
    esac
done

# Install chaotic-aur repository for a lot of precompiled AUR Packages
if [[ -f "/etc/pacman.d/chaotic-mirrorlist" ]]; then
    echo -e "${GREEN}:: [chaotic-aur] repository is already installed${NONE}"
else
    _installChaoticRepository
fi

CHAOTIC_AUR_INSTALLED=1

# Install yay if needed
if [[ $(_checkCommandExists "yay") == 0 ]]; then
    echo -e "${GREEN}:: yay is already installed${NONE}"
else
    echo ":: The installer requires yay. yay will be installed now"
    if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        sudo pacman --noconfirm -S yay-git
    else
        _installYay
    fi
fi

# Packages
_installPackages "${packages[@]}"

# Oh My Posh
if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        _installPackages "oh-my-posh-bin"
else
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

echo
# Prebuild Packages
if [ ! -d $HOME/.local/bin ]; then
    mkdir -p $HOME/.local/bin
fi
echo "Installing Matugen v2.4.1 into ~/.local/bin"
# https://github.com/InioX/matugen/releases
cp $SCRIPT_DIR/packages/matugen $HOME/.local/bin

echo "Installing Wallust v3.4.0 into ~/.local/bin"
# https://codeberg.org/explosion-mental/wallust/releases
cp $SCRIPT_DIR/packages/wallust $HOME/.local/bin

# ML4W Apps
echo ":: Installing the ML4W Apps"

ml4w_app="com.ml4w.welcome"
ml4w_app_repo="dotfiles-welcome"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.settings"
ml4w_app_repo="dotfiles-settings"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.sidebar"
ml4w_app_repo="dotfiles-sidebar"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.calendar"
ml4w_app_repo="dotfiles-calendar"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.hyprlandsettings"
ml4w_app_repo="hyprland-settings"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

# Flatpaks
#flatpak install -y flathub com.github.PintaProject.Pinta

# Fonts
sudo cp -rf $SCRIPT_DIR/fonts/FiraCode /usr/share/fonts
sudo cp -rf $SCRIPT_DIR/fonts/Fira_Sans /usr/share/fonts


echo -e "${GREEN}"
figlet -p "Additional packages"
echo -e "${NONE}"
echo
if gum confirm "Do you want to install my selection of additional packages?"; then
    source ${SCRIPT_DIR}/arch/custom-packages.sh
fi


if [[ "${errorPackages}" ]]; then
    echo -e "${RED}"
    figlet -p "Errors"
    echo ":: Installation finished with errors."
    echo -e "${NONE}"
    echo
    echo "The following packages had errors during installation, please install manually:"
    for pkg in "${errorPackages[@]}"; do
        echo "- ${pkg}"
    done
else
    echo -e "${GREEN}"
    figlet -p "No errors"
    echo ":: Installation completed without errors."
    echo -e "${NONE}"
fi

echo
echo
echo ":: Ready to install the dotfiles with the Dotfiles Installer."
