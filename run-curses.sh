#!/bin/sh
export TERM=xterm-256color
/usr/bin/env lsc -co output src
/usr/bin/env node output/main_curses.js 2> /tmp/lsrl-errors
stty sane
cat /tmp/lsrl-errors
