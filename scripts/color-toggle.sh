#!/usr/bin/env bash

# Master KDE Colorscheme Switcher
# Applies plasma colorscheme and optionally syncs panel-colorizer preset
# Bind this to a keyboard shortcut in KDE settings

QDBUS="qdbus6"
PANEL_SERVICE="luisbocanegra.panel.colorizer.c27.w32"
PRESET_DIR="$HOME/.config/panel-colorizer/presets"

# ── Add your colorschemes here ──────────────────────────────────────────────
# Format: "Label | PlasmaScheme | panel_preset | /wallpaper/path | #accentcolor | Kitty Theme Name"
# Leave any field empty to skip it. Kitty theme name must match `kitten themes` exactly.
SCHEMES=(
    "🌸  Catppuccin Mocha Flamingo  | CatppuccinMochaFlamingo |  | ~/Wallpapers/mocha_flamingo.png | #cba6f7 | Catppuccin-Mocha"
    "🌊  Kanagawa                   | Kanagawa                |                | ~/Wallpapers/kanagawa.png      | #7fb4ca | Kanagawa"
    "🌃  Tokyo Night                | TokyoNight              |                | ~/Wallpapers/tokyo_night.png   | #7aa2f7 | Tokyo Night Storm"
    "🟤  Gruvbox                    | GruvboxColors           |                |~/Wallpapers/gbox.png          | #d79921 | Gruvbox Material Dark Hard"
)
# ──────────────────────────────────────────────────────────────────────────── #

DISPLAY_NAMES=()
for entry in "${SCHEMES[@]}"; do
    label=$(echo "$entry" | cut -d'|' -f1 | sed 's/[[:space:]]*$//')
    DISPLAY_NAMES+=("$label")
done

CHOICE=$(printf '%s\n' "${DISPLAY_NAMES[@]}" | rofi \
    -dmenu \
    -i \
    -p "Color Scheme" \
    -theme-str '
        window {
            width: 420px;
            border-radius: 12px;
        }
        mainbox {
            padding: 8px;
        }
        inputbar {
            padding: 10px 14px;
            border-radius: 8px;
            margin: 0 0 6px 0;
        }
        listview {
            lines: 8;
            fixed-height: false;
        }
        element {
            padding: 10px 14px;
            border-radius: 8px;
            margin: 2px 0;
        }
        element selected {
            border-radius: 8px;
        }
    '
)

[ -z "$CHOICE" ] && exit 0

# Find the matching entry
for entry in "${SCHEMES[@]}"; do
    label=$(echo "$entry" | cut -d'|' -f1 | sed 's/[[:space:]]*$//')
    if [ "$label" = "$CHOICE" ]; then
        plasma_scheme=$(echo "$entry" | cut -d'|' -f2 | tr -d ' ')
        panel_preset=$(echo "$entry"  | cut -d'|' -f3 | xargs)
        wallpaper=$(echo "$entry"     | cut -d'|' -f4 | xargs)
        accent=$(echo "$entry"        | cut -d'|' -f5 | tr -d ' ')
        kitty_theme=$(echo "$entry"   | cut -d'|' -f6 | xargs)
        break
    fi
done

# Apply plasma colorscheme
plasma-apply-colorscheme "$plasma_scheme"

# Sync panel preset if one is defined
if [ -n "$panel_preset" ]; then
    preset_path="$PRESET_DIR/$panel_preset"
    if [ -f "$preset_path" ]; then
        $QDBUS $PANEL_SERVICE /preset preset "$preset_path"
    else
        notify-send "Color Scheme" "⚠️ Panel preset '$panel_preset' not found" --icon=dialog-warning
    fi
fi

# Sync wallpaper if one is defined
if [ -n "$wallpaper" ]; then
    wallpaper="${wallpaper/#\~/$HOME}"  # expand ~ manually
    if [ -f "$wallpaper" ]; then
        plasma-apply-wallpaperimage "$wallpaper"
    else
        notify-send "Color Scheme" "⚠️ Wallpaper not found:\n$wallpaper" --icon=dialog-warning
    fi
fi

# Apply accent color if defined
if [ -n "$accent" ]; then
    plasma-apply-colorscheme --accent-color "$accent"
fi

# Sync kitty theme if defined
if [ -n "$kitty_theme" ]; then
    kitten theme "$kitty_theme"
fi
