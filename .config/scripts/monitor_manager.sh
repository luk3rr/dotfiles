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
    --switch_to_hdmi1)
        ddcutil -b 2 setvcp xf4 x0090 --i2c-source-addr=x50 --noverify
        echo "Switched to HDMI-1!"
        ;;
    --switch_to_hdmi2)
        ddcutil -b 2 setvcp xf4 x0091 --i2c-source-addr=x50 --noverify
        echo "Switched to HDMI-2!"
        ;;
    *)
        echo "שׂ"
        ;;
esac
