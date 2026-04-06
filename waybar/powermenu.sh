#!/usr/bin/bash

confirm () {
    printf "No\nYes" | fuzzel --width 20 --lines 7 --dmenu
}

choice=$(printf "Lock\nSuspend\nReboot\nShutdown" | fuzzel --width 20 --lines 7 --dmenu)

case "$choice" in
    Lock) hyprlock ;;
    Suspend) hyprlock && systemctl suspend ;;
    #Logout) hyprctl dispatch exit ;; # Won't reallly use this
    Reboot) [[ $(confirm) == "Yes" ]] && systemctl reboot ;;
    Shutdown) [[ $(confirm) == "Yes" ]] && systemctl poweroff ;;
esac
