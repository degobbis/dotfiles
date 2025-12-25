#!/usr/bin/env bash
# --------------------------------------------------------------
# ML4W Apps
# --------------------------------------------------------------

declare -A ml4w_flatpak_apps=(
    ["com.ml4w.welcome"]="dotfiles-welcome"
    ["com.ml4w.settings"]="dotfiles-settings"
    ["com.ml4w.sidebar"]="dotfiles-sidebar"
    ["com.ml4w.calendar"]="dotfiles-calendar"
    ["com.ml4w.hyprlandsettings"]="hyprland-settings"
)

echo
echo ":: Flatpak"
flatpak update -y

echo
echo ":: Installing the ML4W Apps"
echo

for ml4w_app in "${!ml4w_flatpak_apps[@]}"
do
    if [[ $(_isInstalledFlatpak "${ml4w_app}") == 0 ]]; then
        echo -e "${GREEN}:: ${ml4w_app} is already installed.${NONE}"
        continue
    fi

    ml4w_app_repo="${ml4w_flatpak_apps[${ml4w_app}]}"

    echo ":: Installing ${ml4w_app} ..."
    bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/${ml4w_app_repo}/master/setup.sh)"
    echo
done

