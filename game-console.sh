#!/bin/sh
export TERM=xterm-256color
echo NodeJS Version: `node -v`
echo -n Building...
node_modules/livescript/bin/lsc -co output src
echo done
echo -n Loading

cd output/front_ends/console/blessed

/usr/bin/env node main.js 2> /tmp/lsrl-errors
stty sane
cat /tmp/lsrl-errors
