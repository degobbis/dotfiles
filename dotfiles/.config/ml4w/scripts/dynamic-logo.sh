#!/bin/bash
# Paths
platform=$(cat ~/.config/ml4w/settings/platform.sh)
logo_path="$HOME/.config/fastfetch/${platform}.png"
output_path="/tmp/arch-colored.png"
cache_dir="$HOME/.cache/fastfetch"

# Extract Pywal colors
color1=$(jq -r '.colors.color0' ~/.cache/wal/colors.json)
color2=$(jq -r '.colors.color10' ~/.cache/wal/colors.json)
color3=$(jq -r '.colors.color13' ~/.cache/wal/colors.json)
color4=$(jq -r '.colors.color15' ~/.cache/wal/colors.json)

# Extract unique colors from the logo image
colors=$(magick "$logo_path" -unique-colors -format "%c" info:)

# Generate an array of the unique colors detected
IFS=$'\n' read -r -d '' -a color_array <<< "$colors"

# Assign Pywal colors to original colors
# This is an example; adjust the assignments as per your actual extracted colors
declare -A color_map
color_map["#a9b1d6"]=$color1
color_map["#c79bf0"]=$color2
color_map["#ebbcba"]=$color3
color_map["#6c7086"]=$color4

# Apply recoloring to the image
magick "$logo_path" \
    $(for color in "${!color_map[@]}"; do
        echo "-fuzz 10% -fill ${color_map[$color]} -opaque $color"
    done) \
    "$output_path"

# clear fastfetch cache
rm -rf "$HOME/.cache/fastfetch"
