#!/usr/bin/env bash

declare -a errorPackages

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
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

# --------------------------------------------------------------
# Write finish message
# --------------------------------------------------------------

_finishMessage() {
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
