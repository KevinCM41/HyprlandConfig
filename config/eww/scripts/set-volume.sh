#!/bin/bash
# First, get the current volume to calculate the difference
current_vol=$(playerctl volume)
target_vol=$(echo "$1" | awk '{printf "%.2f", $1/100}')

# Calculate the difference and apply it
# But this is getting complicated...

# BETTER: Set it absolutely by calculating the multiplier needed
if (( $(echo "$current_vol > 0" | bc -l) )); then
    multiplier=$(echo "$target_vol / $current_vol" | awk '{printf "%.6f", $1}')
    playerctl volume "$multiplier"
fi