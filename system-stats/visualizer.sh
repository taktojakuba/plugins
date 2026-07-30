#!/bin/bash

SIZE=${SIZE:-30}
if [ "$SIZE" = "auto" ]; then
  WIDTH=$(tput cols 2>/dev/null || echo 40)
else
  WIDTH=$SIZE
fi
[ "$WIDTH" -lt 10 ] && WIDTH=40

RATE=44100

MONITOR=$(pactl list sources short 2>/dev/null \
  | awk '/monitor/ && /RUNNING/ {print $2; exit}')
[ -z "$MONITOR" ] && MONITOR=$(pactl list sources short 2>/dev/null \
  | grep -m1 monitor | awk '{print $2}')

level=$(timeout 0.2 parec --raw --format=s16le --rate=$RATE --channels=1 \
  --latency-msec=50 -d "$MONITOR" 2>/dev/null \
  | od -An -td2 -v \
  | awk '{
    for(i=1;i<=NF;i++){
      v=$i<0?-$i:$i
      s+=v*v; n++
    }
  } END {
    if(n>0) printf "%.6f", sqrt(s/n)/32768
    else print "0"
  }')

level_int=$(awk -v l="$level" 'BEGIN{printf "%d", int(l*1000)}')
if [ "${level_int:-0}" -lt 8 ]; then
  printf '%*s' "$WIDTH" | tr ' ' '-'
  echo
  exit 0
fi

body=$(awk -v l="$level" -v w="$WIDTH" 'BEGIN{
  g=l*1.5; if(g>1)g=1; b=int(g*(w-4)+0.5); if(b<0)b=0; if(b>w-4)b=w-4; print b
}')
pad=$((WIDTH - 4 - body))
lpad=$((pad / 2))
rpad=$((pad - lpad))
[ "$lpad" -gt 0 ] && printf '%*s' "$lpad" | tr ' ' '-'
printf '/'
[ "$body" -gt 0 ] && printf '%*s' "$body" | tr ' ' '='
printf '\\'
[ "$rpad" -gt 0 ] && printf '%*s' "$rpad" | tr ' ' '-'
echo
