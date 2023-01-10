#!/bin/env sh

root=$(df / | tr -s "\t" " " | cut -d " " -f 5 | sed -n 2p);
home=$(df /home | tr -s "\t" " " | cut -d " " -f 5 | sed -n 2p);

echo -e  /: $root "  " "~/:" $home
