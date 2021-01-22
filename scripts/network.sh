#!/bin/sh

while :; do
    WIRED_STATE=$(nmcli -p d | awk '/eno1/{print $3; exit}')
    WIFI_STATE=$(nmcli -p d | awk '/wlo1/{print $3; exit}')

    if [ "$WIRED_STATE" = 'connected' ]; then
        echo '  Connected'; sleep 2
    elif [ "$WIFI_STATE" = 'connected' ]; then
        echo '  Connected'; sleep 2
    else
        echo '  Disconnected'; sleep 2
    fi
done
