#!/bin/env sh

artist=$(playerctl metadata | grep :artist | tr -s "\t" " "  | cut -d " " -f 3-)
title=$(playerctl metadata | grep :title | tr -s "\t" " "   | cut -d " " -f 3-)
#album=$(playerctl metadata | grep ":album " | tr -s "\t" " "   | cut -d " " -f 3-)

#if [ -z "$album" ] && [ -z "$artist" ]; then
#    playing=$title;
#
#elif [ -n "$artist" ] && [ -z "$album" ]; then
#    playing="$artist, $title"
#
#else
#    playing="$artist, $title - $album"
#
#fi

if [[ -z $artist ]]; then
    playing=$title

else
    playing="$artist - $title"

fi

strLenght=`echo $playing | wc -c`

if [[ strLenght -gt 60 ]]; then
    echo -e "${playing:0:60} ..."

else
    echo -e $playing

fi
