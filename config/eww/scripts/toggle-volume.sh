#!/bin/bash
# ~/.config/eww/scripts/toggle-volume.sh

if eww active-windows | grep -q "volume-window"; then
  eww close volume-window
else
  eww open volume-window
fi