#!/usr/bin/env bash

current=$(powerprofilesctl get 2>/dev/null)

case "$current" in
    power-saver)
        powerprofilesctl set balanced
        notify-send "Power profile" "Balanced"
        ;;
    balanced)
        powerprofilesctl set performance
        notify-send "Power profile" "Performance"
        ;;
    performance)
        powerprofilesctl set power-saver
        notify-send "Power profile" "Power saver"
        ;;
    *)
        notify-send "Power profile" "Unavailable"
        ;;
esac
