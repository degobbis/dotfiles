#!/usr/bin/env bash

if ! env | grep -i uwsm; then
	pgrep -x solaar >/dev/null && killall -9 solaar
	echo "Start Solaar"
	sleep 1
	solaar show >/dev/null 2>&1
	solaar --window=hide >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x signal-desktop >/dev/null && killall -9 signal-desktop 
	echo "Start Signal"
	sleep 1
	signal-desktop --start-in-tray >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x keepassxc > /dev/null && killall -9 keepassxc 
	echo "Start KeepassXC"
	sleep 1
	keepassxc >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x nextcloud > /dev/null && killall -9 nextcloud 
	echo "Start Nextcloud"
	sleep 1
	nextcloud --background >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x nm-applet > /dev/null && killall -9 nm-applet
	echo "Start NetworkManager Applet"
	sleep 1
	nm-applet >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x blueman-applet > /dev/null && killall -9 blueman-applet
	echo "Start Bluetooth Applet"
	sleep 1
	blueman-applet >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x easyeffects >/dev/null && killall -9 easyeffects
	echo "Start EasyEfects"
	sleep 1
	#easyeffects --hide-window --service-mode --gapplication-service >/dev/null 2>&1 &
	easyeffects --hide-window --gapplication-service >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x udiskie > /dev/null && killall -9 udiskie
	echo "Start Udiskie"
	sleep 1
	udiskie >/dev/null 2>&1 &
	sleep 0.5


	pgrep -x rambox > /dev/null && killall -9 rambox
	echo "Start Rambox"
	sleep 1
	/opt/rambox/rambox --no-sandbox %U >/dev/null 2>&1 &
fi
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

#sleep 1
#killall -SIGUSR2 waybar
#$HOME/.config/waybar/launch.sh &
