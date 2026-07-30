#!/bin/bash

SIZE=${SIZE:-30}
GAIN=${GAIN:-1.5}
if [ "$SIZE" = "auto" ]; then
  WIDTH=$(tput cols 2>/dev/null || echo 40)
else
  WIDTH=$SIZE
fi
[ "$WIDTH" -lt 10 ] && WIDTH=40

if [ "$WIDTH" -lt 14 ]; then
  NBANDS=4
elif [ "$WIDTH" -lt 18 ]; then
  NBANDS=6
elif [ "$WIDTH" -lt 30 ]; then
  NBANDS=8
elif [ "$WIDTH" -lt 45 ]; then
  NBANDS=12
else
  NBANDS=16
fi

max_bands=$WIDTH
[ "$NBANDS" -gt "$max_bands" ] && NBANDS=$max_bands
[ "$NBANDS" -lt 2 ] && NBANDS=2

RATE=44100

MONITOR=$(pactl list sources short 2>/dev/null \
  | awk '/monitor/ && /RUNNING/ {print $2; exit}')
[ -z "$MONITOR" ] && MONITOR=$(pactl list sources short 2>/dev/null \
  | grep -m1 monitor | awk '{print $2}')

spectrum=$(timeout 0.2 parec --raw --format=s16le --rate=$RATE --channels=1 \
  --latency-msec=50 -d "$MONITOR" 2>/dev/null \
  | od -An -td2 -v \
  | awk -v n="$NBANDS" -v gain="$GAIN" '
BEGIN {
  pi = 3.141592653589793
  fmin = 63; fmax = 8000
  lr = log(fmax / fmin) / (n - 1)
  for (b = 1; b <= n; b++) {
    f = fmin * exp(lr * (b - 1))
    o = 2 * pi * f / 44100
    c[b] = 2 * cos(o)
    s1[b] = 0; s2[b] = 0
  }
  chunk = 1024
  ci = 0; ch = 0; N = 0; e = 0
}
{
  for (i = 1; i <= NF; i++) {
    x = $i
    e += (x < 0 ? -x : x)
    ci++; N++
    for (b = 1; b <= n; b++) {
      s0 = x + c[b] * s1[b] - s2[b]
      s2[b] = s1[b]; s1[b] = s0
    }
    if (ci >= chunk) {
      for (b = 1; b <= n; b++) {
        p = s1[b]^2 + s2[b]^2 - s1[b] * s2[b] * c[b]
        ps[b] += p / (ci * ci)
        s1[b] = 0; s2[b] = 0
      }
      ci = 0; ch++
    }
  }
}
END {
  if (ci > 100) {
    for (b = 1; b <= n; b++) {
      p = s1[b]^2 + s2[b]^2 - s1[b] * s2[b] * c[b]
      ps[b] += p / (ci * ci)
      s1[b] = 0; s2[b] = 0
    }
    ch++
  }
  if (ch < 1 || e / N / 32768 < 0.005) { print "QUIET"; exit }
  for (b = 1; b <= n; b++) {
    v = sqrt(ps[b] / ch) / 32768 * gain
    if (v > 0.08) printf "1"; else printf "0"
    if (b < n) printf " "; else printf "\n"
  }
}')

if [ -z "$spectrum" ] || [ "$spectrum" = "QUIET" ]; then
  raw=""
  for ((b = 0; b < NBANDS; b++)); do
    [ -n "$raw" ] && raw="$raw "
    raw="${raw}0"
  done
else
  raw="$spectrum"
fi

FADE_FILE="/tmp/tui-wg-viz-fade"
prev_fade=()
[ -f "$FADE_FILE" ] && read -ra prev_fade < "$FADE_FILE" 2>/dev/null

new_fade=()
body=""
idx=0
for v in $raw; do
  pc=${prev_fade[$idx]:-0}
  if [ "$v" = "1" ]; then
    nc=2
    fb="="
  elif [ "$pc" -gt 0 ]; then
    nc=$((pc - 1))
    fb="="
  else
    nc=0
    fb="-"
  fi
  new_fade[$idx]=$nc
  body="${body}${fb}"
  idx=$((idx + 1))
done

echo "${new_fade[*]}" > "$FADE_FILE"

pd=$((WIDTH - ${#body}))
lp=$((pd / 2))
rp=$((pd - lp))
[ "$lp" -gt 0 ] && printf "%*s" "$lp" | tr " " "-"
printf '%s' "$body"
[ "$rp" -gt 0 ] && printf "%*s" "$rp" | tr " " "-"
echo
