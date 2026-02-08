#!/bin/bash
CONFIG="$HOME/.config/zathura/zathurarc"
MOCHA="$HOME/.config/zathura/zathurarc-mocha"
LATTE="$HOME/.config/zathura/zathurarc-latte"

if readlink "$CONFIG" | grep -q "mocha"; then
    ln -sf "$LATTE" "$CONFIG"
else
    ln -sf "$MOCHA" "$CONFIG"
fi

killall -HUP zathura