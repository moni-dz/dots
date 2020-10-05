#!/bin/bash

current=$(pacmd dump-volumes | awk 'NR==1{print $8}' | sed 's/\%//')

if [ "$#" -eq 0 ]; then
	echo 'Usage: volume.sh <up/down>'
	exit 1;
elif [ "$1" == "up" ]; then
	[ $current -lt 100 ] && pactl set-sink-volume 1 +5%
elif [ "$1" == "down" ]; then
	pactl set-sink-volume 1 -5%
else
	pactl set-sink-mute 1 toggle
fi
