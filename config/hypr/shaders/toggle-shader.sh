#!/bin/bash

# Check if shader is currently active
current_shader=$(hyprctl getoption decoration:screen_shader | grep -o "str: .*" | cut -d' ' -f2-)

if [ "$current_shader" = "[[EMPTY]]" ] || [ -z "$current_shader" ]; then
    # Shader is off, turn it on
    hyprctl keyword decoration:screen_shader ~/.config/hypr/shaders/natural-colors.frag
    notify-send "Display" "Color correction ON" -t 1000
else
    # Shader is on, turn it off
    hyprctl keyword decoration:screen_shader ""
    notify-send "Display" "Color correction OFF" -t 1000
fi