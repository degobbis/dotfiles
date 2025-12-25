#!/usr/bin/env bash
# --------------------------------------------------------------
# Flatpaks
# --------------------------------------------------------------

declare -A flatpak_apps=(
    ["com.github.PintaProject.Pinta"]="Pinta"
)

echo
echo ":: Installing other Flatpak Apps"
echo

for flatpak_app in "${!flatpak_apps[@]}"
do
    if [[ $(_isInstalledFlatpak "${flatpak_app}") == 0 ]]; then
        echo -e "${GREEN}:: ${flatpak_apps[${flatpak_app}]} is already installed.${NONE}"
        continue
    fi

    echo ":: Installing ${flatpak_apps[${flatpak_app}]} ..."
    flatpak install -y flathub "${flatpak_app}"
    echo
done
