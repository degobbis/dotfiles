#!/usr/bin/env bash

echo "Installing Dependencies (cmake, meson, cpio, gcc)"
yay -S --needed --noconfirm cmake meson cpio gcc

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
