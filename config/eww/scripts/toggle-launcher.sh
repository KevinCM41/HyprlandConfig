#!/bin/bash

# Toggle the launcher window
if eww active-windows | grep -q "launcher"; then
  eww close launcher
  eww update search-text=""
else
  eww open launcher
  # Give focus to the input
  sleep 0.1
  hyprctl dispatch focuswindow "^(eww)$"
fi