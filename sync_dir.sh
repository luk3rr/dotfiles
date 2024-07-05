#!/usr/bin/env bash

# Sync all folders in ~/.config and ~/.local to the current directory

CONFIG_PATH=~/.config
FONTS_PATH=~/.fonts
SINK=.
RCLONE_IGNORE="$(pwd)/.rclone_ignore.txt"

FILES_TO_COPY=(
    ".bashrc"
    ".gitconfig"
    ".spacemacs"
    ".tmux.conf.local"
    ".xinitrc"
    ".xprofile"
    ".zshrc"
)

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'  # No Color


function copy_files() {
    files=("$@")
    sink=$SINK

    echo -e "${YELLOW}<><><> COPYING FILES <><><>${NC}"

    for file in "${files[@]}"; do
        from="$HOME/$file"
        to="$sink/$file"

        if [ -f "$from" ]; then
            cp "$from" "$to"
            echo -e "${GREEN}Copied $from to $to${NC}"
        else
            echo -e "${RED}Source file $from does not exist. Skipping${NC}"
        fi
    done

    echo ""
}

function sync() {
    source=$1
    sink=$2
    sink_to=$3

    echo -e "${YELLOW}<><><> SYNCING $source <><><>${NC}"

    # Prevent errors when there are no folders in source
    if compgen -G "$source/*/" > /dev/null; then
        folders=($(ls -d "$source"/*/ | xargs -n 1 basename))

        echo "->> SYNCING FOLDERS <<-"

        for folder in "${folders[@]}"; do
            from="$source/$folder"
            to="$sink_to/$folder"

            if [ -d "$to" ]; then
                if [ -d "$from" ]; then
                    rclone sync --copy-links --exclude-from "$RCLONE_IGNORE" "$from" "$to"
                    echo -e "${GREEN}Folder synced $from -> $to${NC}"
                else
                    echo -e "${RED}Source folder $from does not exist. Skipping${NC}"
                fi
            else
                echo -e "${RED}Destination folder $to does not exist. Skipping sync for $folder${NC}"
            fi
        done
    fi

    # List all files in source, including hidden files, excluding directories
    files=($(find "$source" -maxdepth 1 -type f -exec basename {} \;))

    if [ ${#files[@]} -gt 0 ]; then
        echo -e "->> SYNCING FILES <<-"
    fi

    for file in "${files[@]}"; do
        if [ -f "$sink_to/$file" ]; then
            rclone sync --copy-links --exclude-from "$RCLONE_IGNORE" "$source/$file" "$sink_to/"
            echo -e "${GREEN}File synced $source/$file -> $sink_to/$file${NC}"
        else
            echo -e "${RED}File $source/$file does not exist in destination $sink_to. Skipping sync for $file${NC}"
        fi
    done

    echo ""
}

sync "$CONFIG_PATH" "$SINK" "$SINK/.config"
sync "$FONTS_PATH" "$SINK" "$SINK/.fonts"
copy_files "${FILES_TO_COPY[@]}"
