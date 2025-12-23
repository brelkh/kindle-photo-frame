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

if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE")"
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm -f "$PIDFILE"

        draw_bg
        $FBINK -x $BG_X -y $BG_Y -f 1 "PhotoFrame stopped"
        exit 0
    fi
fi

draw_bg
$FBINK -x $BG_X -y $BG_Y -f 1 "PhotoFrame not running"
exit 0
