#!/usr/bin/env sh

# ██     ██ ██ ███████ ██     ██████   ██████  ███████ ██
# ██     ██ ██ ██      ██     ██   ██ ██    ██ ██      ██
# ██  █  ██ ██ █████   ██     ██████  ██    ██ █████   ██
# ██ ███ ██ ██ ██      ██     ██   ██ ██    ██ ██      ██
#  ███ ███  ██ ██      ██     ██   ██  ██████  ██      ██
#
# AUTHOR: luk3rr
# GITHUB: @luk3rr
#
# This script generates a rofi menu that lists all available networks and allows connect it
#
# Inspired by rofi-bluetooth (https://github.com/nickclyde/rofi-bluetooth)
#
# Depends on: rofi, nmcli
#
# ----------------------------------------------------------------------------------------------------------------------

# table header
fields=IN-USE,SSID,BARS,SECURITY,BSSID
source "$HOME"/.config/rofi/configs/shared/theme.bash
theme="$type/$style"


# Get informations
wifi_list() {
    if wifi_on; then
        availableNetworks=$(nmcli --fields "$fields" device wifi list | sed '/^--/d')
        widthColumn=$(($(echo "$availableNetworks" | head -n 1 | awk '{print length($0); }')+2))
        lineNum=$(echo "$availableNetworks" | wc -l)
        knownConnections=$(nmcli connection show)
    else
        toggle_on
        wifi_list
    fi
}

# Checks if wifi is enabled
wifi_on() {
    if nmcli radio wifi | grep -q "enabled"; then
        return 0
    else
        return 1
    fi
}

# Toggle state
toggle_on() {
    if wifi_on; then
        nmcli radio wifi off
        menu
    else
        nmcli radio wifi on
        sleep 4
        menu
    fi
}

rofi_cmd() {
	rofi -theme-str "window {width: 600;}" \
		-theme-str "listview {columns: 1; lines: 10;}" \
		-theme-str 'textbox-prompt-colon {str: "直 ";}' \
		-dmenu -i \
		-p $prompt \
		-markup-rows \
		-theme ${theme} \
        -lines "$lineNum" \
        -width -"$widthColumn"
}

rofi_passwd() {
	rofi -theme-str "window {height: 150;}" \
        -theme-str "listview {columns: 1; lines: 10;}" \
        -theme-str 'textbox-prompt-colon {str: " ";}' \
		-theme-str 'entry {placeholder: "Password...";}' \
		-dmenu \
		-p $prompt \
		-markup-rows \
		-theme ${theme} \
        -password
}

# Connect in the selected network
connect() {
    ssid=$(echo "$chosen" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $2}')
    if [[ "$ssid" = "SSID" || "$ssid" = "" ]]; then
        return 0
    fi

    # Check if network is known
    if [[ $(echo "$knownConnections" | grep "$ssid") = "$ssid" ]]; then
        nmcli con up "$ssid"

    else
        if [[ "$chosen" =~ "WPA2" ]] || [[ "$chosen" =~ "WEP" ]]; then
            prompt="$ssid"
            pass=$(echo "if connection is stored, press enter" | rofi_passwd)
        fi
        nmcli dev wifi con "$ssid" password "$pass"
    fi
}

menu() {
    # Get menu options
    if wifi_on; then
        status="Wifi: on"
        wifi_list
        prompt="Wi-Fi SSID"
        chosen=$(echo -e "$status\nExit\n$availableNetworks" | uniq -u | rofi_cmd)
    else
        status="Wifi: off"
        prompt="Wi-Fi SSID"
        chosen=$(echo -e "$status\nExit" | uniq -u | rofi_cmd)
    fi
    # Open rofi menu, read chosen option
    # Match chosen option to command
    case $chosen in
        "" | $divider)
            echo "No option chosen."
            ;;
        $status)
            toggle_on
            ;;
        *)
            connect
    esac
}

menu
