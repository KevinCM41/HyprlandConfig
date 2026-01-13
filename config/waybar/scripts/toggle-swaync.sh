#!/bin/bash

visible=$(swaync-client -g | grep "visible" | cut -d ' ' -f2)

if [[ "$visible" == "true" ]]; then
    swaync-client -t
else
    swaync-client -t
fi
