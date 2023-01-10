#!/usr/bin/env sh

arg="${1:-}"

case "$arg" in
    --speakers)
      # my speaker is "alsa_output.pci-0000_08_00.6.analog-stereo"
      SINK=$(pactl list short sinks | grep 3.analog-stereo | cut -f2)
      pacmd set-default-sink "$SINK"
      pacmd list-sink-inputs | grep index | while read line; do
        pacmd move-sink-input $(echo $line | cut -f2 -d' ') "$SINK"
      done
      echo "Switched to speakers!"
      ;;

    --headphones)
      # my headphone is "alsa_output.usb-Corsa_ir_Components_Corsair_HS60_Su_rround_Adapter_v0.1-00.analog-stereo"
      SINK=$(pactl list short sinks | grep Corsair | cut -f2)
      pacmd set-default-sink "$SINK"
      pacmd list-sink-inputs | grep index | while read line; do
        pacmd move-sink-input $(echo $line | cut -f2 -d' ') "$SINK"
      done
      echo "Switched to headphones!"
      ;;

    --bluetooth)
      SINK=$(pactl list short sinks | grep bluez | cut -f2)
      pacmd set-default-sink "$SINK"
      pacmd list-sink-inputs | grep index | while read line; do
        pacmd move-sink-input $(echo $line | cut -f2 -d' ') "$SINK"
      done
      echo "Switched to bluetooth!"
      ;;
    *)
      echo "--speakers, --headphones or --bluetooth 👺"
      ;;
esac
