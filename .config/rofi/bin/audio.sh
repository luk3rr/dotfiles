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

rofi_command="rofi -theme $dir/audio.rasi"

# Gets the current status of playerctl (for us to parse it later on)
status="$(playerctl status)"

# Defines the Play / Pause option content
if [[ $status == "Playing" ]]; then
    play_pause=""
else
    play_pause=""
fi
active=""
urgent=""


# Display if random mode is on / off
stop=""
next=""
previous=""
audio_output=""

# Variable passed to rofi
options="$previous\n$play_pause\n$stop\n$next\n$audio_output"

# Get the current playing song
artist=$(playerctl metadata | grep :artist | tr -s "\t" " "  | cut -d " " -f 3-)
title=$(playerctl metadata | grep :title | tr -s "\t" " "   | cut -d " " -f 3-)

current="$artist - $title"

n=`echo $current | wc -c`
if [[ n -gt 60 ]]; then
    current="${current:0:60} ..."
fi

# Spawn the mpd menu with the "Play / Pause" entry selected by default
chosen="$(echo -e "$options" | $rofi_command -p "$current" -dmenu $active $urgent -selected-row 1)"
case $chosen in
    $previous)
        playerctl previous
        ;;
    $play_pause)
        playerctl play-pause
        ;;
    $stop)
        playerctl stop
        #mpc -q stop
        ;;
    $next)
        playerctl next
        ;;
    $audio_output)
        $HOME/.config/scripts/audio-rofi.sh
        ;;
esac
