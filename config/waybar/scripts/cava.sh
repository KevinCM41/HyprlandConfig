#!/bin/bash

# Bar characters for different heights
bar_chars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

# Run cava and process output
cava -p /dev/stdin 2>/dev/null << EOF | while read -r line; do
[general]
bars = 8
framerate = 60

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 32

[smoothing]
noise_reduction = 77
EOF
    # Convert the raw values to bar characters
    output=""
    for val in $line; do
        if [ "$val" -ge 0 ] 2>/dev/null; then
            # Clamp value to array bounds
            if [ "$val" -gt 7 ]; then
                val=7
            fi
            output="${output}${bar_chars[$val]}"
        fi
    done
    
    # Output for Waybar (must flush immediately)
    echo "$output"
done