#!/usr/bin/env sh

# Getting the data
BATTERY_0_POWER=($(cat /sys/class/power_supply/BAT0/capacity))
BATTERY_0_STATE=($(cat /sys/class/power_supply/BAT0/status))

BATTERY_1_POWER=($(cat /sys/class/power_supply/BAT1/capacity))
BATTERY_1_STATE=($(cat /sys/class/power_supply/BAT1/status))

# Battery icon to reflect on the bar.
ICON_0=""
ICON_1=""

if [[ "${BATTERY_0_STATE}" == *"Charging"* ]] ; then
    ICON_0="  "

else
    if [ "$BATTERY_0_POWER" -gt 75  ]; then
        ICON_0=" "

    elif [ "$BATTERY_0_POWER" -gt 50 ]; then
        ICON_0=" "

    elif [ "$BATTERY_0_POWER" -gt 25 ]; then
        ICON_0=" "

    elif [ "$BATTERY_0_POWER" -gt 0 ]; then
        ICON_0=" "

    else
        ICON_0=" "
    fi
fi

if [[ "${BATTERY_1_STATE}" == *"Charging"* ]] ; then
    ICON_1="  "

else
    if [ "$BATTERY_1_POWER" -gt 75  ]; then
        ICON_1=" "

    elif [ "$BATTERY_1_POWER" -gt 50 ]; then
        ICON_1=" "

    elif [ "$BATTERY_1_POWER" -gt 25 ]; then
        ICON_1=" "

    elif [ "$BATTERY_1_POWER" -gt 0 ]; then
        ICON_1=" "

    else
        ICON_1=" "
    fi
fi

# Format charge & color.
FORMAT="%{F#555}$ICON_0%{F-} $BATTERY_0_POWER% %{F#555}$ICON_1%{F-} $BATTERY_1_POWER%"

# Display on bar
echo $FORMAT
