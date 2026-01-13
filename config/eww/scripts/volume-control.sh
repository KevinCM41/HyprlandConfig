#!/bin/bash

case "$1" in
    "get")
        # Try to get volume from playerctl first
        player_vol=$(playerctl volume 2>/dev/null)
        if [[ -n "$player_vol" && "$player_vol" != "0" ]]; then
            echo "$player_vol" | awk '{printf "%.0f", $1 * 100}'
        else
            # Fallback to system volume
            pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%' || echo '50'
        fi
        ;;
    "set")
        volume="$2"
        # Try playerctl first
        if ! playerctl volume "${volume}/100" 2>/dev/null; then
            # Fallback to system volume
            pactl set-sink-volume @DEFAULT_SINK@ "${volume}%"
        fi
        ;;
    *)
        echo "Usage: $0 {get|set} [volume]"
        exit 1
        ;;
esac