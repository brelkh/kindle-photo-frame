#!/bin/sh

PF_DIR="/mnt/us/photos"
FBINK="/mnt/us/bin/FBInk-v1.25.0-kindle/PW2/bin/fbink"
PIDFILE="/mnt/us/photoframe.pid"

INTERVAL=60
FULLFLASH_EVERY=2
START_DELAY=2   # <-- give KUAL time to finish repainting after tapping Start

# Already running?
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  $FBINK -c "PhotoFrame already running"
  exit 0
fi

pick_random_img() {
  find "$PF_DIR" -maxdepth 1 -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) \
    ! -name '._*' \
    ! -name '.DS_Store' \
    | awk 'BEGIN{srand()} {a[NR]=$0} END{ if(NR>0) print a[int(rand()*NR)+1] }'
}

(
  # Let KUAL finish its delayed repaint first
  sleep "$START_DELAY"

  i=0
  while true; do
    img="$(pick_random_img)"

    if [ -z "$img" ]; then
      $FBINK -c "No images in /mnt/us/photos"
      sleep 10
      continue
    fi

    i=$((i + 1))

    # Full-flash occasionally (and on first render *after* delay)
    if [ "$i" -eq 1 ] || [ $((i % FULLFLASH_EVERY)) -eq 0 ]; then
      $FBINK -c -f -W GC16 -D ORDERED -i "$img"
    else
      $FBINK -c -W GC16 -D ORDERED -i "$img"
    fi

    # Battery overlay (top-left)
    BAT="$(gasgauge-info -c 2>/dev/null)"
    if [ -n "$BAT" ]; then
      $FBINK -x 0 -y 0 "$BAT"
    fi

    sleep "$INTERVAL"
  done
) &

echo $! > "$PIDFILE"
exit 0
