#!/bin/sh
export TERM=xterm-256color
/usr/bin/env lsc src/GameCurses.ls 2> /tmp/lsrl-errors
stty sane
cat /tmp/lsrl-errors
