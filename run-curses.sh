#!/bin/sh
export TERM=xterm-256color
node_modules/livescript/bin/lsc --map embedded -co output src
/usr/bin/env node output/main_curses.js 2> /tmp/lsrl-errors
stty sane
cat /tmp/lsrl-errors
