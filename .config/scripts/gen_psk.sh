#!/usr/bin/env sh

printf "SSID: "
read ssid
printf "Senha: "
read -s passphrase
printf "\n"
wpa_passphrase "$ssid" "$passphrase"
