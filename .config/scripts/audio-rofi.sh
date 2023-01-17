#!/usr/bin/env sh

get_sinks() {
    availableSinks=$(pacmd list-sinks | grep -e 'name:' | cut -d ' ' -f 2 | sed 's/<//g' | sed 's/>//g')
    sinksNames=$(pacmd list-sinks | grep -e 'bluez.alias' -e 'alsa.card_name' | cut -d '=' -f 2 | sed 's/"//g')
    lineNum=$(echo "$availableSinks" | wc -l)
}

menu() {
    get_sinks

    #-format 'i' to return index
    chosen=$(echo -e "$sinksNames" | rofi -dmenu -format 'i' -p "SINK: " -lines "$lineNum")

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
