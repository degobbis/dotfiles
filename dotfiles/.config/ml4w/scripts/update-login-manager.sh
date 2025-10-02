#!/usr/bin/env bash
# Update Login Manager Background
# by Guidfo De Gobbis (2025)
# -----------------------------------------------------

declare -A LM_GREETD_PATHS=(
    ["config"]="/etc"
    ["theme"]="/usr/share"
    ["tpl"]="$HOME/.config/ml4w/tpl"
)

declare -A LM_SDDM_PATHS=(
    ["config"]="/etc/sddm.conf.d"
    ["theme"]="/usr/share/sddm/themes"
    ["tpl"]="$HOME/.config/ml4w/tpl/sddm"
)

sleep 1
clear
ml4w_cache_folder="$HOME/.cache/ml4w/hyprland-dotfiles"
cache_file="${ml4w_cache_folder}/current_wallpaper"
current_wallpaper=$(cat "${cache_file}")
manual_bg_filer=0

if [ ! -z "$1" ]; then
    current_wallpaper=$1
    manual_bg_filer=1
fi

extension="${current_wallpaper##*.}"
target_file="background.${extension}"

figlet -f smslant "Update"
figlet -f smslant "Login Manager"
echo
echo

# Get the active LM name
lm_service_name="$(systemctl status display-manager.service | head -n 1 | cut -d ' ' -f 2)"
lm_name="$(echo ${lm_service_name} | cut -d '.' -f 1)"

# Use nameref to create a dynamic reference to the correct array
declare -n lm_paths="LM_${lm_name^^}_PATHS"

if [ "$lm_name" == "greetd" ]; then
    lm_theme_name="nwg-hello"
    lm_config_path="${lm_paths['config']}/${lm_theme_name}"
fi

if [ "$lm_name" == "sddm" ]; then
    lm_config_path="${lm_paths['config']}"
    lm_theme_name="$(cat < "${lm_config_path}/sddm.conf" | grep -i 'current=' | cut -d'=' -f2)"
fi

lm_theme_path="${lm_paths['theme']}/${lm_theme_name}"
lm_theme_tpl_path="${lm_paths['tpl']}/${lm_theme_name}"

_exit_script() {
    echo
    echo "Press [ENTER] to exit."
    read
    exit
}

_update_background() {
    if [ ! -d "${lm_theme_path}" ]; then
        echo
        echo "Directory ${lm_theme_path} does not exist"
        echo "Is ${lm_theme_name} installed?"
        _exit_script
    fi

    if [ ! -f "${current_wallpaper}" ]; then
        echo
        echo "File ${current_wallpaper} does not exist"
        _exit_script
    fi

    echo ":: Set the current wallpaper ${current_wallpaper} as LoginManager background."
    echo

    sudo cp -f ${current_wallpaper} ${lm_theme_path}/${target_file}
    echo ":: Current wallpaper copied into ${lm_theme_path}"
}

_update_configuration() {
    if [ ! -d "${lm_theme_tpl_path}" ]; then
        echo
        echo "Directory ${lm_theme_tpl_path} for Your custom configuration files does not exist"
        echo "Create it and place Your custom configuration files."
        _exit_script
    fi

    if [ ! -d "${lm_config_path}" ]; then
        echo
        echo "Target directory ${lm_config_path} for configuration files does not exist"
        echo "Is ${lm_theme_name} installed?"
        _exit_script
    fi

    if [ "$lm_name" == "greetd" ]; then
        sudo cp -f ${lm_theme_tpl_path}/* ${lm_config_path}/
    fi

    if [ "$lm_name" == "sddm" ]; then
        if [ -f "${lm_theme_tpl_path}/sddm.conf" ]; then
            sudo cp -f ${lm_theme_tpl_path}/sddm.conf ${lm_config_path}/
        fi
        if [ -f "${lm_theme_tpl_path}/theme.conf" ]; then
            sudo cp -f ${lm_theme_tpl_path}/theme.conf ${lm_theme_path}/
        fi
        if [ -f "${lm_theme_tpl_path}/metadata.desktop" ]; then
            sudo cp -f ${lm_theme_tpl_path}/metadata.desktop ${lm_theme_path}/
        fi
    fi
}

if [ "${manual_bg_filer}" -eq 0 ]; then
    declare -a choices=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedlist"  "Configuration" "Wallpaper")

    # Loop through each selected choice
    echo "${choices[@]}" | while read -r choice; do
        if [ "${choice}" == "Configuration" ]; then
            echo ":: Copy Your custom configuration from ${lm_theme_tpl_path}"
            _update_configuration
        elif [ "${choice}" == "Wallpaper" ]; then
            echo ":: Copy current wallpaper as background into ${lm_theme_path}"
            _update_background
        fi
    done

    echo
    echo "Please logout to see the result."
else
    _update_background
fi

_exit_script
