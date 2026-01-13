#!/bin/bash
# Caps Lock Monitor Script for Hyprland (Wayland)

previous_state=""

# Function to get caps lock state
get_capslock_state() {
    # Check LED state from input device
    if [ -f /sys/class/leds/input*::capslock/brightness ]; then
        cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -n1
        return
    fi
    
    # Fallback: Use hyprctl if available
    if command -v hyprctl &> /dev/null; then
        hyprctl devices -j | jq -r '.keyboards[0].active_keymap' 2>/dev/null
    fi
}

# Initialize the state
previous_state=$(get_capslock_state)

while true; do
    current_state=$(get_capslock_state)
    
    if [ "$current_state" != "$previous_state" ] && [ -n "$current_state" ]; then
        if [ "$current_state" = "1" ]; then
            eww open capslock-popup 2>/dev/null
            sleep 1
            eww close capslock-popup 2>/dev/null
        fi
        previous_state="$current_state"
    fi
    
    sleep 0.1
done