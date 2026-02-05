#!/usr/bin/env bash

declare -a errorPackages
declare -a pkgsToInstall

# --------------------------------------------------------------
# Colors
# --------------------------------------------------------------
# Usage of tput
#
# tput bold # Select bold mode
# tput dim  # Select dim (half-bright) mode
# tput smul # Enable underline mode
# tput rmul # Disable underline mode
# tput rev  # Turn on reverse video mode
# tput smso # Enter standout (bold) mode
# tput rmso # Exit standout mode
#
# tput setab [1-7] # Set the background colour using ANSI escape
# tput setaf [1-7] # Set the foreground colour using ANSI escape
# tput sgr0        # Reset text format to the terminal's default
# tput bel         # Play a bell
#
# Num  Colour
# 0    black
# 1    red
# 2    green
# 3    yellow
# 4    blue
# 5    magenta
# 6    cyan
# 7    white

_error() { tput setaf 1; tput bold; echo "[X]" "$@"; tput sgr 0; tput bel; }
_headline_error() { tput setaf 1; figlet -p "$@"; tput sgr 0; }
_warn() { tput setaf 3; tput bold; echo "[!]" "$@"; tput sgr 0; }
_headline_warn() { tput setaf 3; figlet -p "$@"; tput sgr 0; }
_success() { tput setaf 2; tput bold; echo "[✓]" "$@"; tput sgr 0; }
_headline_success() { tput setaf 2; figlet -p "$@"; tput sgr 0; }
_headline() { tput setaf 6; figlet -p "$@"; tput sgr 0; }
_title() { tput setaf 6; tput bold; echo "::" "$@" "::"; tput sgr 0; }
_info() { tput setaf 7; echo "->" "$@"; tput sgr 0; }


# --------------------------------------------------------------
# Check if command exists
# --------------------------------------------------------------

_checkCommandExists() {
    command -v "$1" >/dev/null
    echo $?
    return
}

# --------------------------------------------------------------
# Write finish message
# --------------------------------------------------------------

_finishMessage() {
    if [[ ${#errorPackages[@]} -gt 0 ]]; then
        _headline_error "Errors"
        _warn "Installation finished with errors!"
        echo
        _info "The following packages had errors during installation"
        echo
        echo "${errorPackages[@]}"
        echo

        if gum confirm "DO YOU WANT TO TRY AGAIN THE INSTALLATION OF THIS PACKEGES WITHOUT AUTOCONFIRMATION?: "; then
            pkgsToInstall=("${errorPackages[@]}")
            errorPackages=()
            echo
            _headline "RE - Installation"
            _info "Start installation."
            echo
            _installErrorPackagesAgain
            _finishMessage
        else
            _warn "Then please install manually."
        fi
    else
        _headline_success "No errors"
        _success ":: Installation completed without errors."
        echo
        echo
        _info "Ready to install the dotfiles with the Dotfiles Installer."
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


# --------------------------------------------------------------
# File Downloader
# --------------------------------------------------------------
#
# Expected values to pass:
# The download URL to the file.
#   --download-url='https://url.to/file.zip'
#
# The name to the target directory the file should be saved.
# The file name is kept, the directory is created if it does not exist.
#   --target-dir='myDirName'
#               Results in the target '/tmp/myDirName/file.zip'.
#
# Optional:
# The sha256sum checksum of the file.
#   --checksum='1496d7505f192bd98691135f364ffe3b4d4541b27c1391ac41e8694f83dda20d'
#
# If a signature file is available for download, add the '--download-sig' option.
# This will automatically download 'https://url.to/file.zip.sig' to the target directory.

_downloadFileToTmp(){
    local downloadURL savePath filename file checksum sumcheck downloadSig downloadSize localSize

    while [[ $# -gt 0 ]]; do
        case $1 in
        --download-url=*)
            downloadURL="$(echo $1 | cut -d '=' -f 2)"
            shift
            ;;
        --target-dir=*)
            savePath="$(echo $1 | cut -d '=' -f 2)"
            shift
            ;;
        --checksum=*)
            checksum="$(echo $1 | cut -d '=' -f 2)"
            shift
            ;;
        --download-sig)
            downloadSig=1
            shift
            ;;
        *)
            shift
            ;;
        esac
    done

    if [[ -z "$downloadURL" ]]; then
        _error "Missing URL to download the file"
        return 1
    fi

    savePath="/tmp/${savePath#/}"
    savePath="${savePath%/}"
    filename="$(basename $downloadURL)"
    file="$savePath/$filename"

    if [[ ! -d "$savePath" ]]; then
        mkdir -p $savePath
    fi

    _info "Start download for $downloadURL"
    if ! curl --progress-bar=dot --retry 3 --connect-timeout 15 -fLOC - $downloadURL --output-dir $savePath; then
        _error "Download for $downloadURL"
        return 1
    fi
    _success "Download for $downloadURL"

    if [[ ! -z "$checksum" ]]; then
        sumcheck="$(echo "$checksum" "$file" | sha256sum -c 2>/dev/null | head -n 1 | awk '{printf $2}')"
        if [[ ! $? -eq 0 ]]; then
            _error "Checksum validation for $file"
            return 1
        fi

        _success "Checksum validation for $file"
        sumcheck=1
    fi

    if [[ -z "$sumcheck" ]]; then
        downloadSize="$(curl --retry 3 --connect-timeout 15 -sL $downloadURL --output /dev/null --write-out '%{size_download}\n')"
        localSize="$(stat -c %s $file)"

        if [[ ! "$localSize" -eq "$downloadSize" ]]; then
            _error "Filesize validation for $file"
            return 1
        else
            _success "Filesize validation for $file"
        fi
    fi

    if [[ "$downloadSig" -eq 1 ]]; then
        _info "Start download for ${downloadURL}.sig"
        if ! curl --progress-bar=dot --retry 3 --connect-timeout 15 -fLOC - ${downloadURL}.sig --output-dir $savePath; then
            _error "Download for ${downloadURL}.sig"
        else
        _success "Download for ${downloadURL}.sig"
        fi
    fi

    downloadedFileToTmp="$file"
    return 0
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
    _title "Install Yay"
    if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        sudo pacman --noconfirm -S yay
    else
        if [[ ! $(_isInstalled "base-devel") == 0 ]]; then
            sudo pacman --noconfirm -S "base-devel"
        fi
        if [[ ! $(_isInstalled "git") == 0 ]]; then
            sudo pacman --noconfirm -S "git"
        fi
        local install_path="/tmp/ml4w/yay"
        local temp_path=$(pwd)
        if [[ -d "$install_path" ]]; then
            rm -rf $install_path
        fi
        git clone https://aur.archlinux.org/yay.git $install_path
        cd $install_path
        makepkg -si
        cd $temp_path
    fi
    _success "Yay has been installed"
}

_installParu() {
    _title "Install Paru"
    if [[ "${CHAOTIC_AUR_INSTALLED}" -eq 1 ]]; then
        sudo pacman --noconfirm -S paru
    else
        if [[ ! $(_isInstalled "base-devel") == 0 ]]; then
            sudo pacman --noconfirm -S "base-devel"
        fi
        if [[ ! $(_isInstalled "git") == 0 ]]; then
            sudo pacman --noconfirm -S "git"
        fi
        local install_path="/tmp/ml4w/paru"
        local temp_path=$(pwd)
        if [[ -d "$install_path" ]]; then
            rm -rf $install_path
        fi
        git clone https://aur.archlinux.org/paru.git $install_path
        cd $install_path
        makepkg -si
        cd $temp_path
    fi
    _success "Paru has been installed"
}

_installAllPackages() {
    $aur_helper --noconfirm -S "${pkgsToInstall[@]}"

    for pkg in "${pkgsToInstall[@]}"; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            _success "${pkg} is already installed"
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
            _success "${pkg} is already installed"
            continue
        fi

        errorPackages+=("${pkg}")
    done

    pkgsToInstall=()
}

_installPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            _success "${pkg} is already installed"
            continue
        fi
        _info "Add ${pkg} to the package list for installation"
        pkgsToInstall+=("${pkg}")
    done
}

_installChaoticRepository(){
    if [[ -f "/etc/pacman.d/chaotic-mirrorlist" ]]; then
        _success "[chaotic-aur] repository is already installed"
        return 0
    fi

    _title "Installing [chaotic-aur] repository for a lot of precompiled AUR Packages"
    _info "sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    _info "sudo pacman-key --lsign-key 3056513887B78AEB"
    sudo pacman-key --lsign-key 3056513887B78AEB

    _downloadFileToTmp \
        --download-url='https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
        --target-dir='ml4w/chaotic-aur' \
        --download-sig

    if [[ $? -eq 0 ]]; then
        _info "sudo pacman -U $downloadedFileToTmp"
        sudo pacman -U $downloadedFileToTmp
    else
        return 1
    fi

    _downloadFileToTmp \
        --download-url='https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' \
        --target-dir='ml4w/chaotic-aur' \
        --download-sig

    if [[ $? -eq 0 ]]; then
        _info "sudo pacman -U $downloadedFileToTmp"
        sudo pacman -U $downloadedFileToTmp
    else
        return 1
    fi

    cat $SCRIPT_DIR/_gdg-arch/chaotic-aur/repository | sudo tee -a /etc/pacman.conf > /dev/null
    _success "[chaotic-aur] repository is now installed"
    _info "Syncing the mirrorlist and update the system packages"
    _info "sudo pacman --noconfirm --disable-download-timeout -Syu"
    sudo pacman --noconfirm --disable-download-timeout -Syu

    return 0
}

_selectAURHelper() {
    _title "Please select your preferred AUR Helper"
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
    _success "Using $aur_helper as AUR Helper"
}

_installPackages "figlet"

# Install chaotic-aur repository for a lot of precompiled AUR Packages
_installChaoticRepository

if [[ $? -eq 0 ]];then
    CHAOTIC_AUR_INSTALLED=1
fi

_selectAURHelper

echo
_title -e "Prepare packages list to install"
