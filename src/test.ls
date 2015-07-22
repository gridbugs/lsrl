#!/usr/bin/env lsc

require! ncurses
require! './CursesDrawer': {CursesDrawer}
require! 'prelude-ls': {map, join, filter}
require! './GameCurses.ls'
require! './Grid.ls': {Grid}
require! './Tiles.ls': {Tiles}

class Cell
    (x, y) ->
        @x = x
        @y = y
    countNeighbours: -> @neighbours |> filter (?) |> (.length)
    toString: -> "(#{@x} #{@y})"

main = ->
    ncurses.showCursor = false
    ncurses.echo = false
    stdscr = new ncurses.Window!
    win0 = new ncurses.Window(40, 120, 0, 0)
    win1 = new ncurses.Window(47, 40, 0, 122)
    win2 = new ncurses.Window(6, 120, 41, 0)

    cleanup = ->
        win0.close!
        win1.close!
        win2.close!
        stdscr.close!
        ncurses.cleanup!

    process.on 'SIGINT' cleanup
    process.on 'exit'   cleanup

    grid = new Grid Cell, 120, 40

    drawer = new CursesDrawer ncurses, win0, win1, win2

    grid.forEach (c) ->
        c.type = Tiles.GRASS
    grid.forEachBorder (c) ->
        c.type = Tiles.WATER
    drawer.drawGrid grid

#main = -> GameCurses.run!

main() if require.main is module
