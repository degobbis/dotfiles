#!/usr/bin/env bash

#pgrep -x easyeffects > /dev/null || easyeffects --gapplication-service &
#sleep 1

#FW_FANCTRL_PID=$(pgrep -f '/usr/bin/python3 fw-fanctrl-ui.py')
#if  [ ! -z "${FW_FANCTRL_PID}" ]; then
#	kill $FW_FANCTRL_PID
#	sleep 1
#fi
#gtk-launch fw-fanctrl-ui.desktop &

#pgrep -x solaar > /dev/null && killall -9 solaar
#sleep 1
#solaar --window=hide &

#pgrep -x solaar > /dev/null || solaar --window=hide &
#sleep 1


#pgrep -x signal-desktop > /dev/null && killall -9 signal-desktop
#sleep 1
#signal-desktop --start-in-tray &

#pgrep -x signal-desktop > /dev/null || signal-desktop --start-in-tray &
#sleep 1


#pgrep -x nextcloud > /dev/null && killall -9 nextcloud
#sleep 1
#nextcloud --background &

#pgrep -x nextcloud > /dev/null || nextcloud --background &
#sleep 1


#sleep 1
#pgrep -x rambox > /dev/null && pkill rambox

#sleep 1
#pgrep -x rambox > /dev/null || rambox --no-sandbox %U

# Please note:
# xdg-desktop-portal-gtk is required to get dark theme on GTK apps.
#
# start xdg-desktop-portal for OpenSnitch
#sleep 1
#pgrep -f xdg-desktop-portal-gtk > /dev/null || /usr/lib/xdg-desktop-portal-gtk

# Start Opensnitch Firewall GUI
#sleep 1
#pgrep -x opensnitch-ui > /dev/null || gtk-launch opensnitch_ui.desktop

# Please note:
# xdg-desktop-portal-gtk is required to get dark theme on GTK apps.
#
#sleep 1
#killall -e xdg-desktop-portal-gtk

# -----------------------------------------------------
# Reload Waybar
# -----------------------------------------------------

#sleep 2
#killall -SIGUSR2 waybar
#$HOME/.config/waybar/launch.sh &
