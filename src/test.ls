#!/usr/bin/env lsc

require! 'prelude-ls': {map, join, filter}
require! './CursesDrawer': {CursesDrawer}
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
    drawer = new CursesDrawer!

    process.on 'SIGINT' drawer.cleanup
    process.on 'exit'   drawer.cleanup

    perlin = new PerlinGenerator!
    grid = new Grid Cell, 120, 40

    const PERLIN_SCALE = 0.1
    grid.forEach (c) ->
        c.type = parseInt(((perlin.getNoise (vec2 (c.x * PERLIN_SCALE), (c.y * PERLIN_SCALE))) + 1) * 5.5)

    grid.forEachBorder (c) ->
        c.type = Tiles.TREE

    drawer.drawGrid grid

#main = -> GameCurses.run!

main() if require.main is module
