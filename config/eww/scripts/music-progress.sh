#!/bin/bash

# File to store last known state
STATE_FILE="/tmp/eww_music_state"

# Get current player status
status=$(playerctl status 2>/dev/null || echo "Stopped")
position_raw=$(playerctl metadata --format '{{position}}' 2>/dev/null || echo "0")
length_raw=$(playerctl metadata --format '{{mpris:length}}' 2>/dev/null || echo "0")
title=$(playerctl metadata title 2>/dev/null || echo "")

# Convert to seconds
position_sec=$(echo "$position_raw" | awk '{print int($1/1000000)}')
length_sec=$(echo "$length_raw" | awk '{print int($1/1000000)}')

# Format times
position_formatted=$(playerctl metadata --format '{{duration(position)}}' 2>/dev/null || echo "0:00")
length_formatted=$(playerctl metadata --format '{{duration(mpris:length)}}' 2>/dev/null || echo "0:00")

# Read previous state if it exists
if [[ -f "$STATE_FILE" ]]; then
    read last_status last_position last_title < "$STATE_FILE"
else
    last_status="Stopped"
    last_position=0
    last_title=""
fi

# Determine current position based on status
if [[ "$status" == "Playing" ]]; then
    current_position=$position_sec
elif [[ "$status" == "Paused" ]]; then
    # If paused, keep the last known position
    if [[ "$title" == "$last_title" ]]; then
        current_position=$last_position
    else
        # New song, use actual position
        current_position=$position_sec
    fi
else
    current_position=0
fi

# Save current state
echo "$status $current_position $title" > "$STATE_FILE"

# Output based on what's requested
case "$1" in
    "position")
        echo "$current_position"
        ;;
    "position-formatted")
        echo "$position_formatted"
        ;;
    "length")
        echo "$length_sec"
        ;;
    "length-formatted")  
        echo "$length_formatted"
        ;;
    *)
        echo "Usage: $0 {position|position-formatted|length|length-formatted}"
        exit 1
        ;;
esac