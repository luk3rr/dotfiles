#!/bin/env sh

# get value
entropy=$(cat /proc/sys/kernel/random/entropy_avail);

# print value
low="%{F#d50000}";
normal="%{F#ff6d00}";
high="%{F#CACAC8}";

if [ $entropy -lt 200 ]
then
    echo -e "$low $entropy %{F-}";
elif [ $entropy -gt 1000 ] && [ $entropy -lt 500 ]
then
    echo -e "$normal $entropy %{F-}";
else
    echo -e "$high $entropy %{F-}";
fi
