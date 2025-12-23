#!/bin/sh

FBINK="/mnt/us/bin/FBInk-v1.25.0-kindle/PW2/bin/fbink"
PF_DIR="/mnt/us/photos"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# fixed background bar
BG_X=0
BG_Y=1
BG_W=40
BG_H=1

draw_bg() {
    $FBINK -X $BG_X -Y $BG_Y -W $BG_W -H $BG_H -b 1
}

draw_bg

# Small overlay, no screen clear
$FBINK -x 0 -y 1 "Updating photos..."

# cd "$SCRIPT_DIR" || exit 1

# python3 update_gphotos.py

# RC=$?

# if [ "$RC" -eq 0 ]; then
#   $FBINK -x 0 -y 1 "Photo update complete"
# else
#   $FBINK -x 0 -y 1 "Photo update failed"
# fi

exit 0
