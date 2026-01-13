#!/bin/bash

if pgrep -x "mako" > /dev/null; then
  notify-send "Notifications Off"
  pkill mako
else
  notify-send "Notifications On"
  mako &
fi