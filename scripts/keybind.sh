#!/usr/bin/env bash

KEYBINDS_FILE="$HOME/.config/rofi/keybinds.txt"

awk -F'│' '{ printf "%-25s │ %s\n", $1, $2 }' "$KEYBINDS_FILE" | rofi \
    -dmenu \
    -i \
    -no-custom \
    -p "Keybinds" \
    -theme-str 'window {width: 800px; height: 500px;} listview {lines: 20;}'
