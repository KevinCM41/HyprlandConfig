#!/bin/bash
if eww active-windows | grep -q "calendar-popup"; then
  eww close calendar-popup
else
  eww open calendar-popup
fi