#!/bin/bash

# Clean up old instances
pkill -f "Xwayland :99" 2>/dev/null
pkill -f "matchbox-window-manager" 2>/dev/null

# 1. Start Xwayland
Xwayland :99 -ac &
XPID=$!
sleep 1

# 2. Start Window Manager (forces window to fill screen)
DISPLAY=:99 matchbox-window-manager &
DISPLAY=:99 autocutsel -s CLIPBOARD -fork &
WMID=$!
sleep 1

# 3. Launch PCoIP Client without unsupported flags
DISPLAY=:99 QT_QPA_PLATFORM=xcb pcoip-client

# Clean up processes on exit
kill $WMID $XPID 2>/dev/null
