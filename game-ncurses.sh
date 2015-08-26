#!/bin/sh
export TERM=xterm-256color
node_modules/livescript/bin/lsc -co output src
cd output/curses
/usr/bin/env node main_curses.js 2> /tmp/lsrl-errors
stty sane
cat /tmp/lsrl-errors
