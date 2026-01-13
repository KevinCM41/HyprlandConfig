#!/usr/bin/env python3
import sys
import json
import subprocess
import argparse

def get_player_status(player=None):
    """Get the current media player status using playerctl"""
    try:
        # Build playerctl command
        cmd = ["playerctl"]
        if player:
            cmd.extend(["-p", player])
        
        # Get metadata
        cmd_metadata = cmd + ["metadata", "--format", "{{artist}}\t{{title}}\t{{playerName}}"]
        result = subprocess.run(cmd_metadata, capture_output=True, text=True, timeout=1)
        
        if result.returncode != 0:
            return None
        
        # Parse metadata
        parts = result.stdout.strip().split('\t')
        if len(parts) < 3:
            return None
            
        artist, title, player_name = parts[0], parts[1], parts[2]
        
        # Get playback status
        cmd_status = cmd + ["status"]
        status_result = subprocess.run(cmd_status, capture_output=True, text=True, timeout=1)
        status = status_result.stdout.strip()
        
        return {
            "artist": artist,
            "title": title,
            "player": player_name.lower(),
            "status": status
        }
        
    except (subprocess.TimeoutExpired, subprocess.CalledProcessError, FileNotFoundError):
        return None

def format_output(data):
    """Format the output for Waybar"""
    if not data:
        return json.dumps({"text": "", "tooltip": "", "class": "stopped"})
    
    # Determine icon based on player
    player = data["player"]
    if "spotify" in player:
        icon = "spotify"
    else:
        icon = "default"
    
    # Format text (artist - title)
    if data["artist"] and data["title"]:
        text = f"{data['artist']} - {data['title']}"
    elif data["title"]:
        text = data["title"]
    else:
        text = "Unknown"
    
    # Determine CSS class based on status
    css_class = "playing" if data["status"] == "Playing" else "paused"
    
    # Create tooltip with full information
    tooltip = f"{data['artist']}\n{data['title']}\n[{data['player']}]"
    
    output = {
        "text": text,
        "tooltip": tooltip,
        "alt": icon,
        "class": css_class
    }
    
    return json.dumps(output)

def main():
    parser = argparse.ArgumentParser(description="Waybar media player module")
    parser.add_argument("--player", help="Filter by player name (e.g., spotify, vlc)")
    args = parser.parse_args()
    
    data = get_player_status(args.player)
    print(format_output(data))

if __name__ == "__main__":
    main()