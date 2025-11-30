#!/usr/bin/env bash

_installAllPackages

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

_installPackages "${systemPackages[@]}"

echo
_installAllPackages
echo

if [[ ${POST_configureFramework16KbdBacklight} -eq 1 ]]; then
    _configureFramework16KbdBacklight
fi

echo

if [[ ${POST_configureLoginManager} -eq 1 ]]; then
    _configureLoginManager
fi

echo

if gum confirm "Do you want to install Hyprland plugins?"; then
    source ${SCRIPT_DIR}/_gdg-arch/hyprland-plugins.sh
fi
