#!/bin/bash
# ~/.config/eww/scripts/toggle-web-nav.sh

if eww active-windows | grep -q "web-nav-window"; then
  eww close web-nav-window
else
  eww open web-nav-window
fi