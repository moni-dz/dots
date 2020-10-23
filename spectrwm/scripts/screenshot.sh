#!/bin/sh
#

screenshot() {
	case $1 in
	area)
		selection=$(hacksaw -c b84b33 -f "-i %i -g %g")
		shotgun $selection - | xclip -t 'image/png' -selection clipboard
		;;
	full)
		shotgun ~/Pictures/screenshots/$(date +%s).png
		;;
	*)
		;;
	esac;
}

screenshot $1
