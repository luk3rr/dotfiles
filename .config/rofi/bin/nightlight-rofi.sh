#!/usr/bin/env sh

# AUTHOR: luk3rr
# GITHUB: @luk3rr
#
# This is script generates a rofi menu that lists some kelvin values
# and allows changing display temp

# ----------------------------------------------------------------------------------------------------------------------

source "$HOME"/.config/rofi/configs/shared/theme.bash
theme="$type/$style"

# https://github.com/jonls/redshift/blob/master/README-colorramp
# ["KELVIN_VALUE"="GAMMA_VALUE"]
declare GAMMA_VALUES=(["2000"]="1.00000000:0.54360078:0.08679949"
                      ["2100"]="1.00000000:0.56618736:0.14065513"
                      ["2200"]="1.00000000:0.58734976:0.18362641"
                      ["2300"]="1.00000000:0.60724493:0.22137978"
                      ["2400"]="1.00000000:0.62600248:0.25591950"
                      ["2500"]="1.00000000:0.64373109:0.28819679"
                      ["2600"]="1.00000000:0.66052319:0.31873863"
                      ["2700"]="1.00000000:0.67645822:0.34786758"
                      ["2800"]="1.00000000:0.69160518:0.37579588"
                      ["2900"]="1.00000000:0.70602449:0.40267128"
                      ["3000"]="1.00000000:0.71976951:0.42860152"
                      ["3100"]="1.00000000:0.73288760:0.45366838"
                      ["3200"]="1.00000000:0.74542112:0.47793608"
                      ["3300"]="1.00000000:0.75740814:0.50145662"
                      ["3400"]="1.00000000:0.76888303:0.52427322"
                      ["3500"]="1.00000000:0.77987699:0.54642268"
                      ["3600"]="1.00000000:0.79041843:0.56793692"
                      ["3700"]="1.00000000:0.80053332:0.58884417"
                      ["3800"]="1.00000000:0.81024551:0.60916971"
                      ["3900"]="1.00000000:0.81957693:0.62893653"
                      ["4000"]="1.00000000:0.82854786:0.64816570"
                      ["4100"]="1.00000000:0.83717703:0.66687674"
                      ["4200"]="1.00000000:0.84548188:0.68508786"
                      ["4300"]="1.00000000:0.85347859:0.70281616"
                      ["4400"]="1.00000000:0.86118227:0.72007777"
                      ["4500"]="1.00000000:0.86860704:0.73688797"
                      ["4600"]="1.00000000:0.87576611:0.75326132"
                      ["4700"]="1.00000000:0.88267187:0.76921169"
                      ["4800"]="1.00000000:0.88933596:0.78475236"
                      ["4900"]="1.00000000:0.89576933:0.79989606"
                      ["5000"]="1.00000000:0.90198230:0.81465502"
                      ["5100"]="1.00000000:0.90963069:0.82838210"
                      ["5200"]="1.00000000:0.91710889:0.84190889"
                      ["5300"]="1.00000000:0.92441842:0.85523742"
                      ["5400"]="1.00000000:0.93156127:0.86836903"
                      ["5500"]="1.00000000:0.93853986:0.88130458"
                      ["5600"]="1.00000000:0.94535695:0.89404470"
                      ["5700"]="1.00000000:0.95201559:0.90658983"
                      ["5800"]="1.00000000:0.95851906:0.91894041"
                      ["5900"]="1.00000000:0.96487079:0.93109690"
                      ["6000"]="1.00000000:0.97107439:0.94305985"
                      ["6100"]="1.00000000:0.97713351:0.95482993"
                      ["6200"]="1.00000000:0.98305189:0.96640795"
                      ["6300"]="1.00000000:0.98883326:0.97779486"
                      ["6400"]="1.00000000:0.99448139:0.98899179"
                      ["6500"]="1.00000000:1.00000000:1.00000000"
                  )
# xrandr is unable to set kelvins between 1000 and 1900 because blue gamma is zero.
# see https://gitlab.freedesktop.org/xorg/app/xrandr/-/merge_requests/5

get_display_name() {
    displays=$(xrandr --verbose | grep -w "connected" | cut -d " " -f 1)
}

get_display_gamma() {
    gamma=$(xrandr --verbose | grep "$display" -A5 | grep "Gamma:" | cut -d " " -f 7)
}

availabre_gamma() {
    for value in "${!GAMMA_VALUES[@]}"; do
        options+="${value}K\n"
    done
}

rofi_cmd() {
	rofi -theme-str "window {height: 290;}" \
		-theme-str "listview {columns: 1; lines: 10;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
        -theme-str 'entry {placeholder: "Choose display...";}' \
		-dmenu \
		-p $prompt \
		-markup-rows \
        -lines "$lineNum" \
		-theme ${theme}
}

rofi_temp() {
	rofi -theme-str "window {height: 500;}" \
		-theme-str "listview {columns: 1; lines: 10;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
        -theme-str 'entry {placeholder: "Choose temperature...";}' \
		-dmenu \
		-p $prompt \
		-markup-rows \
        -lines "$lineNum" \
		-theme ${theme}
}

menu() {
    get_display_name

    prompt="Display"
    display=$(echo -e "$displays" | uniq -u | rofi_cmd)
    
    if [[ -n $display ]]; then
        get_display_gamma
        availabre_gamma
        
        prompt="$display"
        chosen=$(echo -e "Reset\n$options\n" | uniq -u | rofi_temp)
        
        chosen=$(cut -d "K" -f 1 <<< $chosen)

        if [[ $chosen == "Reset" ]]; then
            xrandr --output $display --gamma ${GAMMA_VALUES[6500]}

        elif [[ -n $chosen ]]; then
            xrandr --output $display --gamma ${GAMMA_VALUES[$chosen]}
        fi
    fi
}

menu
