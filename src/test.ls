#!/usr/bin/env lsc

require! './GameCurses.ls'
require! './Grid.ls': {Grid}

main = ->
    a = new Grid 40 20
    console.log a.array[0][0].neighbours
    a.__forEachInternal (x) ->
        console.log x

#main = -> GameCurses.run!

main() if require.main is module
