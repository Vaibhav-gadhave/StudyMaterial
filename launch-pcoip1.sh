#!/bin/bash

# Clean up old instances
pkill -f "Xwayland :98" 2>/dev/null
pkill -f "matchbox-window-manager" 2>/dev/null

# 1. Start Xwayland
Xwayland :98 -ac &
XPID=$!
sleep 1

# 2. Start Window Manager (forces window to fill screen)
DISPLAY=:98 matchbox-window-manager &
WMID=$!
sleep 1

# 3. Launch PCoIP Client without unsupported flags
DISPLAY=:98 QT_QPA_PLATFORM=xcb pcoip-client

# Clean up processes on exit
kill $WMID $XPID 2>/dev/null
