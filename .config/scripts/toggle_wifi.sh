#!/usr/bin/sh

# This script makes the Ethernet and Wifi mutually exclusive.
# To use it, you should copy it to "/{etc,usr/lib}/NetworkManager/dispatcher.d" and enable
# its execution with "chmod +x toggle_wifi.sh." For more information, refer to
# https://man.archlinux.org/man/NetworkManager-dispatcher.8.en
# OBS.: You need to enable the dispatcher service for the script to be executed every time a
#       network interface change occurs:
#       1. systemctl enable NetworkManager-dispatcher.service
#       2. systemctl start NetworkManager-dispatcher.service


# Set the LC_ALL environment variable to "C" to configure the shell's locale
export LC_ALL=C

# Toggle wifi when LAN is connected/Disconnected
ToggleWifi() {
    result=$(nmcli dev | grep "ethernet" | grep -w "unavailable")

    if [ -n "$result" ]; then
        nmcli radio wifi on
    else
        nmcli radio wifi off
    fi
}

ToggleWifi
