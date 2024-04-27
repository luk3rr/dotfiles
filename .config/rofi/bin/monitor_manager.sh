#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Adapted by luk3rr

# ----------------------------------------------------------------------------

# styles: circle, rounded or square
style="square"

dir="$HOME/.config/rofi/configs/$style"

rofi_command="rofi -theme $dir/monitor_manager.rasi"

# Icons
wide_on_above="󰍺 "
wide_on_right="󰍹 󰍹 "
wide_off="󰍹 "
nightlight="望"
hdmi_1="󰡁 1"
hdmi_2="󰡁 2"

# Options in menu
options="$wide_on_right\n$wide_on_above\n$wide_off\n$nightlight\n$hdmi_1\n$hdmi_2"

# Spawn the monitor_manager menu
chosen="$(echo -e "$options" | $rofi_command -p "Monitor Manager" -dmenu $active $urgent -selected-row 1)"
case $chosen in
    $wide_on_right)
        $HOME/.config/scripts/monitor_manager.sh --wide_on_right
        ;;
    $wide_on_above)
        $HOME/.config/scripts/monitor_manager.sh --wide_on_above
        ;;
    $wide_off)
        $HOME/.config/scripts/monitor_manager.sh --wide_off
        ;;
    $nightlight)
        $HOME/.config/rofi/bin/nightlight-rofi.sh
        ;;
    $hdmi_1)
        $HOME/.config/scripts/monitor_manager.sh --switch_to_hdmi1
        ;;

    $hdmi_2)
        $HOME/.config/scripts/monitor_manager.sh --switch_to_hdmi2
        ;;
esac
