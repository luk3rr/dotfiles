#!/usr/bin/env sh

# Getting the data
BATTERY_0_POWER=($(cat /sys/class/power_supply/BAT0/capacity))
BATTERY_0_STATE=($(cat /sys/class/power_supply/BAT0/status))

BATTERY_1_POWER=($(cat /sys/class/power_supply/BAT1/capacity))
BATTERY_1_STATE=($(cat /sys/class/power_supply/BAT1/status))

# Battery icon
BATTERY_PLUGGED="󰚥"
BATTERY_100="󰁹"
BATTERY_90="󰂂"
BATTERY_80="󰂁"
BATTERY_70="󰂀"
BATTERY_60="󰁿"
BATTERY_50="󰁾"
BATTERY_40="󰁽"
BATTERY_30="󰁼"
BATTERY_20="󰁻"
BATTERY_10="󰁺"
BATTERY_WARN="󱃍"

# Battery icon
# param: $1 - battery state
# param: $2 - battery percentage
# return: battery icon
function battery_icon() {
    if [[ "$1" == *"Charging"* ]] ; then
        echo $BATTERY_PLUGGED

    else
        if [ "$2" -ge 99  ]; then
            echo $BATTERY_100

        elif [ "$2" -ge 89 ]; then
            echo $BATTERY_90

        elif [ "$2" -ge 79 ]; then
            echo $BATTERY_80

        elif [ "$2" -ge 69 ]; then
            echo $BATTERY_70

        elif [ "$2" -ge 59 ]; then
            echo $BATTERY_60

        elif [ "$2" -ge 49 ]; then
            echo $BATTERY_50

        elif [ "$2" -ge 39 ]; then
            echo $BATTERY_40

        elif [ "$2" -ge 29 ]; then
            echo $BATTERY_30

        elif [ "$2" -ge 19 ]; then
            echo $BATTERY_20

        elif [ "$2" -ge 9 ]; then
            echo $BATTERY_10

        else
            echo $BATTERY_WARN
        fi
    fi
}

ICON_0=$(battery_icon $BATTERY_0_STATE $BATTERY_0_POWER)
ICON_1=$(battery_icon $BATTERY_1_STATE $BATTERY_1_POWER)

# display on bar
echo "%{F#555}$ICON_0%{F-} $BATTERY_0_POWER% %{F#555} $ICON_1%{F-} $BATTERY_1_POWER%"
