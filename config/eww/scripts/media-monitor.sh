#!/bin/bash
# Media Keys Monitor Script for Hyprland

# Function to get mute status
get_mute_status() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes' && echo "1" || echo "0"
}

# Function to get mic mute status
get_mic_mute_status() {
    pactl get-source-mute @DEFAULT_SOURCE@ | grep -q 'yes' && echo "1" || echo "0"
}

# Monitor for mute changes
previous_mute=$(get_mute_status)
previous_mic_mute=$(get_mic_mute_status)

while true; do
    current_mute=$(get_mute_status)
    current_mic_mute=$(get_mic_mute_status)
    
    # Check if mic mute status changed
    if [ "$current_mic_mute" != "$previous_mic_mute" ]; then
        if [ "$current_mic_mute" = "1" ]; then
            eww update mic-status="Mic Muted"
        else
            eww update mic-status="Mic Unmuted"
        fi
        eww open mic-mute-popup 2>/dev/null
        sleep 1
        eww close mic-mute-popup 2>/dev/null
        previous_mic_mute="$current_mic_mute"
    fi
    
    # Check if mute status changed
    if [ "$current_mute" != "$previous_mute" ]; then
        if [ "$current_mute" = "1" ]; then
            eww open mute-popup 2>/dev/null
            sleep 1
            eww close mute-popup 2>/dev/null
        else
            eww open unmute-popup 2>/dev/null
            sleep 1
            eww close unmute-popup 2>/dev/null
        fi
        previous_mute="$current_mute"
    fi
    
    sleep 0.1
done