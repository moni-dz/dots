if [ "$1" = "up" ]; then
    xbacklight -inc 10
elif [ "$1" = "down" ]; then
    xbacklight -dec 10
else
    echo 'Usage: brightness <up/down>'
    exit 0;
fi
