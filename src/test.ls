#!/usr/bin/env lsc

require! './GameNcurses.ls'

main = -> GameNcurses.run!

main() if require.main is module
