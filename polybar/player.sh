#!/bin/env sh

artist=$(playerctl metadata | grep :artist | tr -s "\t" " "  | cut -d " " -f 3-)
title=$(playerctl metadata | grep :title | tr -s "\t" " "   | cut -d " " -f 3-)
album=$(playerctl metadata | grep ":album " | tr -s "\t" " "   | cut -d " " -f 3-)

if [ -z "$album" ] && [ -z "$artist" ]; then
    echo -e $title;
elif [ -n "$artist" ] && [ -z "$album" ]; then
    echo -e $artist, $title
else
    echo -e $artist, $title - $album;
fi
