#!/usr/bin/env bash

while :; do
    # Wired Connection
    WIRED_STATE=$(nmcli -p d | awk '/eno1/{print $3; exit}')

    # Wifi Connection
    WIFI_STATE=$(nmcli -p d | awk '/wlo1/{print $3; exit}')
    SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

    #WIRED=$(nmcli -p d | awk '/eno1/{print $4; exit}')
    #WIFI=$(nmcli -p d | awk '/wlo1/{print $4; exit}')

    if [ "$WIRED_STATE" = 'connected' ]; then
        echo '   Connected'; sleep 2
    elif [ "$WIFI_STATE" = 'connected' ]; then
        echo '   Connected'; sleep 2
    else
        echo ' 睊  Disconnected'; sleep 0.5
    fi
done
