#!/bin/bash

# Get initial volume
get_volume() {
    pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\d+%' | head -1 | tr -d '%'
}

# Output initial value
get_volume

# Listen for changes
pactl subscribe | grep --line-buffered "source" | while read -r _; do
    get_volume
done