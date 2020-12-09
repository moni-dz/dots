#!/bin/sh

current=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
sink=$(pactl list short sinks | awk 'NR==1{print $1}')

if [ "$#" -eq 0 ]; then
	echo 'Usage: volume.sh <up/down>'
	exit 1;
elif [ "$1" = "up" ]; then
	[ "$current" -lt 100 ] && pactl set-sink-volume "$sink" +5%
elif [ "$1" = "down" ]; then
	pactl set-sink-volume "$sink" -5%
else
	pactl set-sink-mute "$sink" toggle
fi
