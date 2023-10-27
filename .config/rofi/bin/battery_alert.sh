#!/usr/bin/env bash

# AUTHOR: luk3rr
# GITHUB: @luk3rr

# ----------------------------------------------------------------------------

style="square"
dir="$HOME/.config/rofi/bin/powermenu"
theme='style-1'
rofi_command="rofi -theme $HOME/.config/rofi/configs/square/powermenu.rasi"

BATTERY_0_POWER=($(cat /sys/class/power_supply/BAT0/capacity))
BATTERY_1_POWER=($(cat /sys/class/power_supply/BAT1/capacity))

# Options
okay='﫠 Okay'

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 1; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Battery is low :(' \
        -theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$okay" | confirm_cmd
}

if [[ $BATTERY_0_POWER -le "10" && $BATTERY_1_POWER -le "5"  ]]; then
    playerctl pause
    amixer set Master mute
    systemctl suspend

elif [[ $BATTERY_0_POWER -le "15" && $BATTERY_1_POWER -le "10" ]]; then
    confirm_exit
fi
