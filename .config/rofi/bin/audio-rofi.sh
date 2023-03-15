#!/usr/bin/env sh

#  ________  ___  ___  ________  ___  ________          ________  ________  ________ ___
# |\   __  \|\  \|\  \|\   ___ \|\  \|\   __  \        |\   __  \|\   __  \|\  _____\\  \
# \ \  \|\  \ \  \\\  \ \  \_|\ \ \  \ \  \|\  \       \ \  \|\  \ \  \|\  \ \  \__/\ \  \
#  \ \   __  \ \  \\\  \ \  \ \\ \ \  \ \  \\\  \       \ \   _  _\ \  \\\  \ \   __\\ \  \
#   \ \  \ \  \ \  \\\  \ \  \_\\ \ \  \ \  \\\  \       \ \  \\  \\ \  \\\  \ \  \_| \ \  \
#    \ \__\ \__\ \_______\ \_______\ \__\ \_______\       \ \__\\ _\\ \_______\ \__\   \ \__\
#     \|__|\|__|\|_______|\|_______|\|__|\|_______|        \|__|\|__|\|_______|\|__|    \|__|
#
# AUTHOR: luk3rr
# GITHUB: @luk3rr
#
# This script generates a rofi menu that lists all sinks and allows switch it
#
# Inspired by rofi-bluetooth (https://github.com/nickclyde/rofi-bluetooth)
#
# Depends on: rofi, pacmd
#
# -----------------------------------------------------------------------------------------------------------------------

source "$HOME"/.config/rofi/configs/shared/theme.bash
theme="$type/$style"

get_sinks() {
    availableSinks=$(pacmd list-sinks | grep -e 'name:' | cut -d ' ' -f 2 | sed 's/<//g' | sed 's/>//g')
    lineNum=$(echo "$availableSinks" | wc -l)
    sinksDescription="$(pacmd list-sinks | grep -e 'device.description' | cut -d '=' -f 2 | sed 's/"//g')"
    sinksNames="$(pacmd list-sinks | grep -e 'bluez.alias' -e 'alsa.name' | cut -d '=' -f 2 | sed 's/"//g')"

    sinksCardNamesFormatted=""
    while read -r line; do
        line_cut=$(echo "$line" | cut -c 1-50)
        line_formatted=$(printf "%-50s" "$line_cut")
        sinksCardNamesFormatted="$sinksCardNamesFormatted$line_formatted\n"
    done <<< "$sinksDescription"

    finalOutput=$(paste -d '' <(echo -e "$sinksCardNamesFormatted") <(echo -e "$sinksNames"))
}

rofi_cmd() {
    # -format 'i' to return index
	rofi -theme-str 'window {height: 290; width: 700;}' \
		-theme-str 'textbox-prompt-colon {str: "";}' \
        -theme-str 'entry {placeholder: "Device...";}' \
		-dmenu -i \
        -format 'i' \
		-p $prompt \
        -lines "$lineNum" \
		-theme ${theme}
}

menu() {
    get_sinks

    prompt="SINK"
    chosen=$(echo "$finalOutput" | rofi_cmd)

    if [[ "$chosen" == "" ]]; then
        return 0

    else
        declare -a availabre=($availableSinks)
        pacmd set-default-sink "${availabre[$chosen]}"
    fi

    defaultSink=$(pacmd stat | grep -e 'Default sink name:' | cut -d ':' -f 2)
    echo "Current default sink: $defaultSink 👺"
}

menu
