#!/usr/bin/env sh

get_sinks() {
    availableSinks=$(pacmd list-sinks | grep -e 'name:' | cut -d ':' -f 2)
    lineNum=$(echo "$availableSinks" | wc -l)
}

menu() {
    get_sinks
    chosen=$(echo -e "$availableSinks" | uniq -u | rofi -dmenu -p "SINK: " -lines "$lineNum")

    if [[ "$chosen" == "" ]]; then
        return 0

    else
        # Cut '< >' of chosen name
        chosen="${chosen:2:-1}"
        pacmd set-default-sink "$chosen"
    fi
    defaultSink=$(pacmd stat | grep -e 'Default sink name:' | cut -d ':' -f 2)
    echo "Current default sink: $defaultSink 👺"
}

menu
