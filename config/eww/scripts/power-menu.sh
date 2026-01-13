#!/bin/bash

# Check if power-menu-window is open
if eww active-windows | grep -q "power-menu-window"; then
    # Force close both windows
    eww close power-menu-window
    eww close power-menu-bg
    exit 0
fi

# Open windows
eww open power-menu-bg
eww open power-menu-window