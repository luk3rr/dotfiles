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

rofi_command="rofi -theme $dir/open_workspace.rasi"

# Options
music=""
mail=""

# Variable passed to rofi
options="$music\n$mail"

chosen="$(echo -e "$options" | $rofi_command -p "Open Layout" -dmenu -selected-row 2)"
case $chosen in
    $music)
        $HOME/.config/i3/load_layout-music.sh
        ;;
    $mail)
        $HOME/.config/i3/load_layout-mail.sh
        ;;
    esac
