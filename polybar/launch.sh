#!/bin/bash

# Terminate already running bar instances
kill -9 $(pgrep polybar)
#polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
# while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar top &

echo "Bars launched..."
