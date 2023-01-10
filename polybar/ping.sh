#!/bin/env sh

ping=$(ping -c 1 www.google.com | sed -n 2p | cut -d "=" -f 4);
check=$(ping -c 1 www.google.com | sed -n 2p | cut -d "=" -f 4 | cut -d " " -f 2);
if [ "$check" == "ms" ]; then
    echo $ping
else
    exit $1
fi
