#!/usr/bin/env sh

function set_brightness() {
    local brightness="$2"
    ddcutil setvcp 0x10 "$brightness"
}

function select_brightness() {
    local monitor="$1"
    local options=("25" "50" "75" "100")  # Valores de brilho pré-definidos
    local selected_option=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Selecione o brilho:")

    if [[ -n "$selected_option" ]]; then
        set_brightness "$monitor" "$selected_option"
    fi
}

main() {
    local monitor=1  # Número do monitor que deseja ajustar

    select_brightness "$monitor"
}

main
