#!/bin/sh

FBINK="/mnt/us/bin/FBInk-v1.25.0-kindle/PW2/bin/fbink"
PIDFILE="/mnt/us/photoframe.pid"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    $FBINK -o -x 0 -y 1 "PhotoFrame: RUNNING"
else
    $FBINK -o -x 0 -y 1 "PhotoFrame: STOPPED"
fi

exit 0
