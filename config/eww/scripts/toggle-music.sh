#!/bin/bash
# ~/.config/eww/scripts/toggle-music.sh
# Improved toggle script with better error handling

# Check if EWW daemon is running
if ! pgrep -x eww > /dev/null; then
    echo "EWW daemon not running, starting..."
    eww daemon &
    sleep 1
fi

# Check if window is open
if eww active-windows | grep -q "music-popup"; then
    echo "Closing music popup..."
    eww close music-popup
else
    echo "Opening music popup..."
    # Make sure window is closed first
    eww close music-popup 2>/dev/null
    sleep 0.1
    # Open the window
    eww open music-popup
    
    # Check if it opened successfully
    if eww active-windows | grep -q "music-popup"; then
        echo "Music popup opened successfully"
    else
        echo "Failed to open music popup - check EWW logs"
        eww logs | tail -10
    fi
fi