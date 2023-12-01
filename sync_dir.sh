#!/usr/bin/env/ sh

# Sincronizar arquivos dotfiles com o repositório que será enviado para o remoto

source=~/.config
sink=./

cd "$sink/.config" || exit

folders=($(ls -d */))

for folder in "${folders[@]}"; do
    from="$source/$folder"
    to="$sink/$folder"
    rsync -av "$from" "$to"
done
