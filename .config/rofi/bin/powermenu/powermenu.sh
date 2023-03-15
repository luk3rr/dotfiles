#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Adapted by luk3rr

# ----------------------------------------------------------------------------

# styles: circle, rounded or square
style="square"
dir="$HOME/.config/rofi/bin/powermenu"
theme='style-1'
rofi_command="rofi -theme $HOME/.config/rofi/configs/square/powermenu.rasi"

batteryTime=$(upower -i /org/freedesktop/UPower/devices/DisplayDevice | grep "time to" | sed 's/ //g;s/timeto.*://g;s/minutes/ min/g;s/hours/ h/g')
batteryState=$(upower -i /org/freedesktop/UPower/devices/DisplayDevice | grep "state" | sed 's/ //g' | cut -d ':' -f 2)

if [[ "$batteryState" == "charging" ]]; then
    batteryState="to full charge"

elif [[ "$batteryState" == "discharging" ]]; then
    batteryState="to full discharge"

fi

cpu=$($HOME/.config/rofi/bin/usedcpu)
memory=$($HOME/.config/rofi/bin/usedram)

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""
yes='﫠 Yes'
no=' No'


# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$host" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "$batteryTime $batteryState"  -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == $yes ]]; then
			systemctl poweroff
		elif [[ $ans == $no ]]; then
			exit 0
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == $yes ]]; then
			systemctl reboot
		elif [[ $ans == $no ]]; then
			exit 0
        fi
        ;;
    $lock)
		if [[ -f /usr/bin/i3lock ]]; then
			betterlockscreen -l dim && betterlockscreen -u ~/data/000.*/005.*/ALL_FHD/FAVORITES_FHD/
		elif [[ -f /usr/bin/betterlockscreen ]]; then
			i3lock
		fi
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == $yes ]]; then
			playerctl pause
			amixer set Master mute
			systemctl suspend
		elif [[ $ans == $no ]]; then
			exit 0
        fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == $yes ]]; then
			if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			fi
		elif [[ $ans == $no ]]; then
			exit 0
        fi
        ;;
esac
