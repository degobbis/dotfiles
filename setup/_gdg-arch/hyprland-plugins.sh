#!/usr/bin/env bash

declare -a hyprlandPluginsDependency=(
    "cmake"
    "meson"
    "cpio"
    "gcc"
)
echo "Installing Dependencies (cmake, meson, cpio, gcc)"
_installPackages "${hyprlandPluginsDependency[@]}"
_installAllPackages

echo
hyprpm update
echo

if gum confirm "Do you want to install 'split-monitor-workspaces' (https://github.com/Duckonaut/split-monitor-workspaces)?"; then
    hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
    hyprpm enable split-monitor-workspaces
fi

if gum confirm "Do you want to install 'hyprbars' (https://github.com/hyprwm/hyprland-plugins)?"; then
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm enable hyprbars
fi

echo
