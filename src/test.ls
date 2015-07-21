#!/usr/bin/env lsc

require! './GameCurses.ls'

main = -> GameCurses.run!

main() if require.main is module
