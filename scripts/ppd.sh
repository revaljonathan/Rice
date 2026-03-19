#!/usr/bin/env bash
# Power Profile Switcher
# Bind this script to a keyboard shortcut in KDE settings

# Returns a random comment from a pool
pick_comment() {
    local -n pool=$1
    echo "${pool[$((RANDOM % ${#pool[@]}))]}"
}

COMMENTS_PERFORMANCE=(
    "Performance mode. Your laptop will now sound like a jet engine. Hope it's worth it."
    "Oh, Performance mode. Very cool. Your fans will be working harder than you ever have."
    "Nice. Burning through battery for that extra 3fps. Totally necessary."
    "Performance mode activated. Please enjoy your 45 minutes of battery life."
    "Ah yes, Performance. Because Balanced was just too responsible for you."
    "Going full Performance? Bold move for someone who just has 12 browser tabs open."
)

COMMENTS_BALANCED=(
    "Balanced. The Switzerland of power profiles. Very courageous decision."
    "Back to Balanced. Couldn't commit to either extreme. Classic."
    "Balanced mode. For people who want mediocrity, but make it intentional."
    "Ah, Balanced. The 'I'll start the diet on Monday' of power profiles."
    "Balanced. Not too hot, not too cold. You must be so fun at parties."
    "Balanced mode. Truly a decision made by someone who reads the manual."
)

COMMENTS_POWERSAVER=(
    "Power Saver. Either your battery is dying or you are. Either way, relatable."
    "Power Saver mode. Your CPU weeps softly in the background."
    "Oh, Power Saver. Planning to be away from an outlet for a while, or just anxious?"
    "Power Saver. Your laptop will now perform like it's running on hopes and dreams."
    "Brave choice. Nothing says productivity like a 200MHz effective clock speed."
    "Power Saver activated. Your laptop will now be slower than your decision-making."
)

PROFILES=(
    "Performance"
    "Balanced"
    "Power Saver"
)

CHOICE=$(printf '%s\n' "${PROFILES[@]}" | rofi \
    -dmenu \
    -i \
    -p "Power Profile" \
    -theme-str '
        window {
            width: 400px;
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
            lines: 4;
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

case "$CHOICE" in
    *"Performance"*)
        powerprofilesctl set performance
        notify-send "Power Profile" "$(pick_comment COMMENTS_PERFORMANCE)" --icon=preferences-system-performance
        ;;
    *"Balanced"*)
        powerprofilesctl set balanced
        notify-send "Power Profile" "$(pick_comment COMMENTS_BALANCED)" --icon=battery-good
        ;;
    *"Power Saver"*)
        powerprofilesctl set power-saver
        notify-send "Power Profile" "$(pick_comment COMMENTS_POWERSAVER)" --icon=battery-caution
        ;;
esac
