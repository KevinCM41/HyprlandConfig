#!/bin/bash
echo "wifi script running"
# Find the active Wi-Fi interface
interface=$(iw dev | awk '$1=="Interface"{print $2}' | head -n1)

# Get the signal level (in dBm)
signal=$(iw dev "$interface" link | awk '/signal:/ {print $2}')

# Convert signal (dBm) to percentage (approximate)
if [ "$signal" != "" ]; then
    # Example: -30 dBm = 100%, -90 dBm = 0%
    strength=$((2 * ($signal + 100)))
    # Clamp to 0–100 range
    strength=$((strength < 0 ? 0 : (strength > 100 ? 100 : strength)))
    echo "📶 ${strength}%"
else
    echo "⚠ No connection"
fi
