#!/bin/bash

# Get the artist and title from YT Music
artist=$(playerctl -p YoutubeMusic metadata artist 2>/dev/null)
title=$(playerctl -p YoutubeMusic metadata title 2>/dev/null)

# Check if YT Music is running and playing
status=$(playerctl -p YoutubeMusic status 2>/dev/null)

if [ -z "$status" ]; then
    echo "YT Music not running"
    exit 1
fi

if [ "$status" = "Playing" ]; then
    icon="󰎇"  # Playing icon
elif [ "$status" = "Paused" ]; then
    icon="󰏤"  # Paused icon
else
    icon="󰓃"  # Stopped icon
fi

# Display the song info
if [ -n "$artist" ] && [ -n "$title" ]; then
    echo "$icon $artist - $title"
else
    echo "$icon No song info available"
fi