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

rofi_command="rofi -theme $dir/network.rasi"

## Get info
IFACE="$(nmcli | grep -i interface | awk '/interface/ {print $2}')"
#SSID="$(iwgetid -r)"
#LIP="$(nmcli | grep -i server | awk '/server/ {print $2}')"
#PIP="$(dig +short myip.opendns.com @resolver1.opendns.com )"
STATUS="$(nmcli radio wifi)"

active=""
urgent=""

# BUG SE O CABO RJ-45 ESTIVER CONECTADO
if (ping -c 1 archlinux.org || ping -c 1 google.com || ping -c 1 bitbucket.org || ping -c 1 github.com || ping -c 1 sourceforge.net) &>/dev/null; then
	if [[ $STATUS == *"enable"* ]]; then
        if [[ $IFACE == e* ]]; then
            connected=""
        else
            connected=""
        fi
	active="-a 0"
	SSID="﬉ $(iwgetid -r)"
	PIP="$(wget --timeout=30 http://ipinfo.io/ip -qO -)"
	fi
else
    urgent="-u 0"
    SSID="Disconnected"
    PIP="Not Available"
    connected=""
fi

## Icons
wifi=""
launch_cli=""
launch=""
bluetooth=""

options="$connected\n$wifi\n$bluetooth\n$launch_cli\n$launch"

## Main
chosen="$(echo -e "$options" | $rofi_command -p "$SSID : $PIP" -dmenu $active $urgent -selected-row 1)"
case $chosen in
    $connected)
		if [[ $STATUS == *"enable"* ]]; then
			nmcli radio wifi off
		else
			nmcli radio wifi on
		fi 
        ;;
    $wifi)
        $HOME/.config/scripts/wifi.sh
        ;;
    $bluetooth)
        $HOME/.config/scripts/bluetooth.sh
        ;;
    $launch_cli)
        termite -e nmtui
        ;;
    $launch)
        nm-connection-editor
        ;;
esac

