#!/bin/env sh

i3-msg "workspace 10; append_layout /home/luk3rr/.config/i3/workspace-10.json";
(kitty -e cava &);
(spotify &);
