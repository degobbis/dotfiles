#!/usr/bin/env bash
# --------------------------------------------------------------
# Flatpaks
# --------------------------------------------------------------

#declare -A flatpak_apps=(
#    ["com.github.PintaProject.Pinta"]="Pinta"
#)

#echo
#_title "Installing other Flatpak Apps"

#for flatpak_app in "${!flatpak_apps[@]}"
#do
#    if [[ $(_isInstalledFlatpak "${flatpak_app}") == 0 ]]; then
#        _success "${flatpak_apps[${flatpak_app}]} is already installed."
#        continue
#    fi

#    _info "Installing ${flatpak_apps[${flatpak_app}]} ..."
#    flatpak install -y flathub "${flatpak_app}"
#    echo
#done
