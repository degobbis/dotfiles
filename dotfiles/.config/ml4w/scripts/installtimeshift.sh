#!/bin/bash
#  _____ _                     _     _  __ _
# |_   _(_)_ __ ___   ___  ___| |__ (_)/ _| |_
#   | | | | '_ ` _ \ / _ \/ __| '_ \| | |_| __|
#   | | | | | | | | |  __/\__ \ | | | |  _| |_
#   |_| |_|_| |_| |_|\___||___/_| |_|_|_|  \__|
#

sleep 1
clear
figlet -f smslant "Timeshift"
aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"

_isInstalledAUR() {
    package="$1"
    $aur_helper -Q --color always "${package}" 2>1 > /dev/null
    echo $?
    return
}

timeshift_installed=$(_isInstalledAUR "timeshift")
grubbtrfs_installed=$(_isInstalledAUR "grub-btrfs")

if [[ $timeshift_installed == "0" ]]; then
    echo ":: Timeshift is already installed"
else
    if gum confirm "DO YOU WANT TO INSTALL Timeshift now?"; then
        $aur_helper -S timeshift
    fi
fi
if [[ -d /boot/grub ]] && [[ $grubbtrfs_installed == "0" ]]; then
    echo ":: grub-btrfs is already installed"
else
    echo ":: grub-btrfs is required to select a snapshot on grub bootloader."
    if gum confirm "DO YOU WANT TO INSTALL grub-btrfs now?"; then
        $aur_helper -S grub-btrfs
    fi
fi
sleep 3
