#!/bin/sh

FBINK="/mnt/us/bin/FBInk-v1.25.0-kindle/PW2/bin/fbink"
PIDFILE="/mnt/us/photoframe.pid"

# fixed background bar
BG_X=0
BG_Y=1
BG_W=40
BG_H=1

draw_bg() {
    $FBINK -X $BG_X -Y $BG_Y -W $BG_W -H $BG_H -b 1
}

draw_bg

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    $FBINK -x $BG_X -y $BG_Y -f 1 "PhotoFrame: RUNNING"
else
    $FBINK -x $BG_X -y $BG_Y -f 1 "PhotoFrame: STOPPED"
fi

exit 0
