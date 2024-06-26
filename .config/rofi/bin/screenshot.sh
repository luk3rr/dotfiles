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

rofi_command="rofi -theme $dir/screenshot.rasi"

# Error msg
msg() {
	rofi -theme "$HOME/.config/rofi/configs/styles/message.rasi" -e "Please install 'maim' first."
}

# Options
screen=""
area=""
window=""

# Variable passed to rofi
options="$screen\n$area\n$window"
date=$(date +%Y%m%d-%kh%Mm%Ss | sed 's/ /0/g')
screenshot_dir="$HOME/Pictures/Screenshots"

if [ ! -d "$screenshot_dir" ]; then
	mkdir -p "$screenshot_dir"
fi

chosen="$(echo -e "$options" | $rofi_command -p 'maim' -dmenu -selected-row 1)"
case $chosen in
$screen)
	if [[ -f /usr/bin/maim ]]; then
		sleep 1
		maim -d 3 "$screenshot_dir/screenshot_$date.png" | xclip -selection clipboard -t image/png
	else
		msg
	fi
	;;
$area)
	if [[ -f /usr/bin/maim ]]; then
		maim --select | tee "$screenshot_dir/screenshot_$date.png" | xclip -selection clipboard -t image/png
	else
		msg
	fi
	;;
$window)
	if [[ -f /usr/bin/maim ]]; then
		maim -d 3 -i $(xdotool getactivewindow) | tee "$screenshot_dir/screenshot_$date.png" | xclip -selection clipboard -t image/png
	else
		msg
	fi
	;;
esac
