#!/bin/sh

/run/current-system/sw/bin/xss-lock slock
/run/current-system/sw/bin/xidlehook --not-when-fullscreen --not-when-audio --timer 600 slock
