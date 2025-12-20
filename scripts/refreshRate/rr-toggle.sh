
#!/bin/bash

# ===== HARD LOCK (PALING AWAL, NO NEGO) =====
LOCK="/tmp/refresh_toggle.lock"
exec 9>"$LOCK" || exit 1
flock -n 9 || exit 0
trap 'rm -f "$LOCK"' EXIT

# ===== DEBOUNCE (ANTI KEY REPEAT KDE BANGSAT) =====
sleep 0.4

# ===== CONFIG =====
OUTPUT="eDP-1"
RES="1920x1200"
STATE="$HOME/.cache/refresh_state"

mkdir -p "$HOME/.cache"
[ ! -f "$STATE" ] && echo "60" > "$STATE"

current=$(cat "$STATE")

if [ "$current" = "60" ]; then
    target="165"
else
    target="60"
fi

# ===== EXEC KIALOG (KILL PARENT BIAR GA LOOP) =====
exec kdialog --title "Refresh Rate" \
    --yesno "Change refresh rate to ${target} Hz?"

# ===== CODE DI BAWAH INI GA AKAN JALAN KALO NO =====
if [ $? -eq 0 ]; then
    kscreen-doctor output.$OUTPUT.mode.$RES@$target
    echo "$target" > "$STATE"
fi

