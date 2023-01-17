#!/usr/bin/env sh

arg="${1:-}"

case "$arg" in
    --wide_off)
        xrandr --output HDMI2 --off
        echo "Single mode activated!"
        ;;
    --wide_on)
        xrandr --output eDP1 --mode 1920x1080 --primary --output HDMI2 --mode 2560x1080 --above eDP1
        echo "Dual mode activated!"
        ;;
    *)
        echo "שׂ"
        ;;
esac
