#!/usr/bin/env sh

min_signal_diff_for_switching=12

# Lets do a scan first
sudo nmcli -t -f ssid,signal,rate,in-use dev wifi rescan

# And get the list of known networks
known_networks_info=$(nmcli -t -f name connection show | sed -e 's/^Auto //g')

# What's the current network, yet?
current_network_name=$(nmcli -t -f ssid,signal,rate,in-use dev wifi list | grep ':\*' | cut -d ':' -f1)
current_network_strength=$(nmcli -t -f ssid,signal,rate,in-use dev wifi list | grep ':\*' | cut -d ':' -f2)

# Now see if we have a better network to switch to. Networks are sorted by signal strength so there's no need to check them all if the first signal's strength is not higher than current network's strength + min_signal_diff_for_switching.
for network in $(nmcli -t -f ssid,signal,rate,in-use dev wifi list | grep -v $current_network_name | sort -nr -k2 -t':') ; do
        network_name=$(echo $network | cut -d ':' -f1)
        network_strength=$(echo $network | cut -d ':' -f2)
        if [[ "$network_name" == "" ]]; then continue ; fi # MESH hotspots may appear with an non existent SSID so we skip them
        if [[ "$known_networks_info" == *"$network_name"* ]]; then
                if [ $network_strength -ge $(($current_network_strength + 12)) ]; then
                        notification="Switching to network $network_name that has a better signal ($network_strength>$(($current_network_strength + 12)))"
                        echo $notification
                        notify-send "$notification"
                        sudo nmcli device wifi connect $network_name
                else
                        #echo "Network $network_name is well known but its signal's strength is not worth switching."
                        exit 0
                fi
        fi
done
