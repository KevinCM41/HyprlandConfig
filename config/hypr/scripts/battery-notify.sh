#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/BAT0"
WARNED=0

while true; do
    CAPACITY=$(cat $BATTERY_PATH/capacity)
    STATUS=$(cat $BATTERY_PATH/status)
    
    if [ "$STATUS" = "Discharging" ]; then
        if [ $CAPACITY -le 15 ] && [ $WARNED -eq 0 ]; then
            notify-send -u critical "Battery Low" "${CAPACITY}% remaining"
            WARNED=1
        elif [ $CAPACITY -le 10 ]; then
            notify-send -u critical "Battery Critical" "${CAPACITY}% remaining"
        fi
    else
        WARNED=0
    fi
    
    sleep 60
done