#!/bin/sh
export TERM=xterm-256color
src/test.ls 2> /tmp/lsrl-errors
stty sane
cat /tmp/lsrl-errors
