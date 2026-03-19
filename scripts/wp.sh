#!/usr/bin/env bash
FOLDER_A="$HOME/Pictures/catppuccin/"   # 👈 change this
FOLDER_B="$HOME/Pictures/wp/"           # 👈 change this
COLUMNS=4
THUMB_SIZE=200

# ── Step 1: pick a folder ────────────────────────────────────────────────────
FOLDER=$(
    printf '%s\n' \
        "🌸  Catppuccin" \
        "🟤  Misc" \
    | rofi \
        -dmenu \
        -i \
        -p "" \
        -no-custom \
        -theme-str "
            window   { width: 340px; border-radius: 12px; }
            mainbox  { padding: 8px; spacing: 6px; }
            inputbar { enabled: false; }
            listview { lines: 2; columns: 1; spacing: 6px; fixed-height: false; }
            element  { padding: 8px 12px; border-radius: 8px; }
        "
)
[ -z "$FOLDER" ] && exit 0
case "$FOLDER" in
    *Catppuccin*) WALLPAPER_DIR="$FOLDER_A" ;;
    *Misc*)       WALLPAPER_DIR="$FOLDER_B" ;;
    *)            exit 1 ;;
esac

# ── Step 2: pick a wallpaper from that folder ────────────────────────────────
TMPFILE=$(mktemp)
find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | sort > "$TMPFILE"

INDEX=$(
    cat "$TMPFILE" \
        | while read -r filepath; do
            printf ' \x00icon\x1f%s\n' "$filepath"
        done \
    | rofi \
        -dmenu \
        -i \
        -p "" \
        -show-icons \
        -format i \
        -no-custom \
        -theme-str "
            window {
                width: 850px;
                border-radius: 12px;
            }
            mainbox {
                padding: 8px;
                spacing: 6px;
            }
            inputbar { enabled: false; }
            listview {
                columns: $COLUMNS;
                lines: 2;
                fixed-height: false;
                flow: horizontal;
                spacing: 6px;
            }
            element {
                orientation: vertical;
                padding: 3px;
                border-radius: 8px;
                spacing: 0px;
            }
            element-icon {
                size: ${THUMB_SIZE}px;
                border-radius: 6px;
            }
            element-text {
                font: \"Sans 0\";
                padding: 0;
                margin: 0;
            }
            element selected {
                border-radius: 8px;
            }
        "
)
[ -z "$INDEX" ] && { rm "$TMPFILE"; exit 0; }
SELECTED=$(sed -n "$((INDEX + 1))p" "$TMPFILE")
rm "$TMPFILE"

if [ -n "$SELECTED" ]; then
    SARCASTIC_COMMENTS=(
        "Wow, another wallpaper. Truly living on the edge."
        "Bold choice. Really bold. ...Is it though?"
        "Changed again? Commitment issues much?"
        "Oh look, a new wallpaper you'll replace in 10 minutes."
        "Groundbreaking. Your desktop is basically fine art now."
        "Sure, this one will DEFINITELY stick around."
        "You do know the wallpaper doesn't affect performance, right?"
        "Another one. Your wallpaper folder must be exhausted."
        "Life-changing decision. Truly. History will remember this."
        "Applied. Your desktop is marginally less boring now."
        "This one sparks joy? We'll see about that."
        "Cool. Very cool. Did it fix your problems? Didn't think so."
        "You scrolled through all those just to pick... that one."
        "Ah yes, the classic 'rearrange things instead of doing tasks' move."
    )
    COMMENT="${SARCASTIC_COMMENTS[$RANDOM % ${#SARCASTIC_COMMENTS[@]}]}"
    plasma-apply-wallpaperimage "$SELECTED"
    notify-send "Wallpaper" "$COMMENT" --icon=preferences-desktop-wallpaper
fi
