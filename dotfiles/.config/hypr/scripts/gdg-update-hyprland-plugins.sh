#!/usr/bin/env bash

# Update hyprland plugins after hyprland-git update

VERSION_FILE="$HOME/.config/hypr/version"
CURRENT_VERSION=$(pacman -Qe "hyprland" | awk '{print $NF }')

if [[ ! -f "$VERSION_FILE" ]] || [[ "$(cat "$VERSION_FILE")" != "$CURRENT_VERSION" ]]; then
    notify-send -u critical "Hyprland-Plugins werden aktualisiert..." "Bitte warten, bis das Update abgeschlossen ist."
    
    sleep 5

    # Plugins updaten
    $(cat ~/.config/ml4w/settings/terminal.sh) --class dotfiles-floating -e hyprpm update

    # Falls Update erfolgreich, speichern wir die neue Version
    if [[ $? -eq 0 ]]; then
        swaync-client --hide-latest
        notify-send -u normal "Hyprland-Plugin-Update abgeschlossen!" "Du kannst Hyprland jetzt normal nutzen."
    else
        notify-send -u critical "Hyprland-Plugin-Update FEHLGESCHLAGEN!" "Überprüfe mit 'hyprpm update -v' in der Konsole die Fehler."
        exit 1
    fi

    echo "$CURRENT_VERSION" > "$VERSION_FILE"
else
    notify-send -u normal "Hyprland-Plugins sind Aktuell, kein Update nötig."
fi
