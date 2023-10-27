#!/usr/bin/env sh

arg="${1:-}"

case "$arg" in
    --wide_off)
        xrandr --output HDMI2 --off
        echo "Single mode activated!"
        ;;
    --wide_on_above)
        xrandr --output eDP1 --mode 1920x1080 --primary --output HDMI2 --mode 2560x1080 --above eDP1
        echo "Dual mode activated! (above)"
        ;;
    --wide_on_right)
        xrandr --output eDP1 --mode 1920x1080 --primary --output HDMI2 --mode 1920x1080 --above eDP1
        echo "Dual mode activated! (right)"
        ;;
    *)
        echo "שׂ"
        ;;
esac
