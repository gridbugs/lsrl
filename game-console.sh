#!/bin/sh
export TERM=xterm-256color

echo -n Building...
node_modules/livescript/bin/lsc -co output src
echo done
echo -n Loading

if [ "$1" = "--blessed" ]; then
    cd output/front_ends/console/blessed
else
    cd output/front_ends/console/curses
fi
/usr/bin/env node main.js 2> /tmp/lsrl-errors
stty sane
cat /tmp/lsrl-errors
