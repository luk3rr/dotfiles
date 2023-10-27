#!/usr/bin/env sh

voltageBatteryZero=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "voltage:" | sed 's/ //g' | sed 's/:/ /g' | cut -d " " -f 2 | sed 's/V//g')
voltageBatteryOne=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep "voltage:" | sed 's/ //g' | sed 's/:/ /g' | cut -d " " -f 2 | sed 's/V//g')

capacityBatteryZeroInWh=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy:" | sed 's/ //g' | sed 's/:/ /g' | cut -d " " -f 2 | sed 's/Wh//g')
capacityBatteryOneInWh=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep "energy:" | sed 's/ //g' | sed 's/:/ /g' | cut -d " " -f 2 | sed 's/Wh//g')

capacityBatteryZeroInAh=$capacityBatteryZeroInWh/$voltageBatteryZero
capacityBatteryOneInAh=$capacityBatteryOneInWh/$voltageBatteryOne


