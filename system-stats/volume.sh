#!/bin/sh

out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

if echo "$out" | grep -q MUTED; then
    echo "Muted"
else
    awk '{printf "%d%%\n", $2*100}' <<<"$out"
fi
