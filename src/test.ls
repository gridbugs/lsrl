#!/usr/bin/env lsc

require! ncurses
require! './CursesDrawer': {CursesDrawer}
require! 'prelude-ls': {map, join, filter}
require! './GameCurses.ls'
require! './Grid.ls': {Grid}
require! './Tiles.ls': {Tiles}
require! './Perlin.ls': {PerlinGenerator}
require! './Vec2.ls': {vec2}

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

    perlin = new PerlinGenerator!
    grid = new Grid Cell, 120, 40
    drawer = new CursesDrawer ncurses, win0, win1, win2

    const PERLIN_SCALE = 0.1
    grid.forEach (c) ->
        c.type = parseInt(((perlin.getNoise (vec2 (c.x * PERLIN_SCALE), (c.y * PERLIN_SCALE))) + 1) * 5.5)

#    grid.forEachBorder (c) ->
#        c.type = 14


    drawer.drawGrid grid

#main = -> GameCurses.run!

main() if require.main is module
