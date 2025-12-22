#!/bin/sh

FBINK="/mnt/us/bin/FBInk-v1.25.0-kindle/PW2/bin/fbink"
PIDFILE="/mnt/us/photoframe.pid"

if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE")"
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm -f "$PIDFILE"
        $FBINK -c "PhotoFrame stopped"
        exit 0
    fi
fi

$FBINK -c "PhotoFrame not running"
exit 0
