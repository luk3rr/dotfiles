#!/usr/bin/env sh

# table header
fields=IN-USE,SSID,BARS,SECURITY,BSSID

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
            pass=$(echo "if connection is stored, press enter" | rofi -dmenu -p "Password" -password -lines 1)
        fi
        nmcli dev wifi con "$ssid" password "$pass"
    fi
}

menu() {
    # Get menu options
    if wifi_on; then
        status="Wifi: on"
        wifi_list
        chosen=$(echo -e "$status\nExit\n$availableNetworks" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines "$lineNum" -width -"$widthColumn")
    else
        status="Wifi: off"
        chosen=$(echo -e "$status\nExit" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: ")
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

rofi_command="rofi -dmenu $@ -p"
menu
