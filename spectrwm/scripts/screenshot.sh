#!/bin/sh
#

screenshot() {
	case $1 in
	full)
		maim -s | xclip -selection clipboard -t image/png
		;;
	window)
		sleep 1
		maim ~/Pictures/screenshots/$(date +%s).png
		;;
	*)
		;;
	esac;
}

screenshot $1
