#!/usr/bin/env bash

confirm () {
    printf "No\nYes" | 
        fuzzel --dmenu \
            --prompt="Confirm $1? > " \
            --lines=2 \
            --width=24
}

choice=$(printf "  Lock\n󰤄  Suspend\n󰜉  Reboot\n  Shutdown" |
    fuzzel --dmenu \
        --prompt="System > " \
        --lines=4 \
        --width=24)

case "$choice" in
    *Lock) hyprlock ;;
    *Suspend) hyprlock && systemctl suspend ;;
    #Logout) hyprctl dispatch exit ;; # Won't reallly use this
    *Reboot) [[ $(confirm "Reboot") == "Yes" ]] && systemctl reboot ;;
    *Shutdown) [[ $(confirm "Shutdown") == "Yes" ]] && systemctl poweroff ;;
esac
