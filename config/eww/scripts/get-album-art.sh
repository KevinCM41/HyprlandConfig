#!/bin/bash
# ~/.config/eww/scripts/get-album-art.sh
CACHE_DIR="$HOME/.cache/eww/album_art"
DEFAULT_ART="$HOME/.config/eww/assets/default-album.png"
CURRENT_TRACK_FILE="/tmp/eww_current_track"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Get current track info for caching - ONLY from YoutubeMusic
CURRENT_TITLE=$(playerctl -p YoutubeMusic metadata title 2>/dev/null || echo "")
CURRENT_ARTIST=$(playerctl -p YoutubeMusic metadata artist 2>/dev/null || echo "")
CURRENT_TRACK="${CURRENT_ARTIST} - ${CURRENT_TITLE}"

# Check if we have a cached version for current track
if [ -f "$CURRENT_TRACK_FILE" ] && [ "$(cat "$CURRENT_TRACK_FILE")" = "$CURRENT_TRACK" ]; then
    CACHED_ART="$CACHE_DIR/current_album_art.jpg"
    if [ -f "$CACHED_ART" ]; then
        echo "$CACHED_ART"
        exit 0
    fi
fi

# Get album art URL from playerctl - ONLY from YoutubeMusic
ART_URL=$(playerctl -p YoutubeMusic metadata mpris:artUrl 2>/dev/null)

if [ -n "$ART_URL" ] && [ "$ART_URL" != "" ]; then
    # Handle different URL schemes
    case "$ART_URL" in
        file://*)
            # Local file
            ART_PATH="${ART_URL#file://}"
            if [ -f "$ART_PATH" ]; then
                # Copy to cache with standard name
                cp "$ART_PATH" "$CACHE_DIR/current_album_art.jpg" 2>/dev/null
                echo "$CURRENT_TRACK" > "$CURRENT_TRACK_FILE"
                echo "$CACHE_DIR/current_album_art.jpg"
            else
                echo "$DEFAULT_ART"
            fi
            ;;
        http://*|https://*)
            # Remote URL - download it
            CACHED_ART="$CACHE_DIR/current_album_art.jpg"
            if curl -s -L "$ART_URL" -o "$CACHED_ART" 2>/dev/null; then
                echo "$CURRENT_TRACK" > "$CURRENT_TRACK_FILE"
                echo "$CACHED_ART"
            else
                echo "$DEFAULT_ART"
            fi
            ;;
        *)
            echo "$DEFAULT_ART"
            ;;
    esac
else
    echo "$DEFAULT_ART"
fi