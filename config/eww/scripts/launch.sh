#!/bin/bash

# Initialize brightness value
current=$(brightnessctl get)
max=$(brightnessctl max)
percent=$((current * 100 / max))
eww update brightness-value=$percent

# Open the brightness window
eww open brightness-window