#!/usr/bin/env lsc

require! 'prelude-ls': {map, join, filter}
require! './PerlinTestGenerator.ls': {PerlinTestGenerator}
require! './CellAutomataTestGenerator.ls': {CellAutomataTestGenerator}

class Cell
    (x, y) ->
        @x = x
        @y = y
    toString: -> "(#{@x} #{@y})"

export test = (drawer) ->
    c = new CellAutomataTestGenerator!
    p = new PerlinTestGenerator!
    grid = c.generate Cell, 120, 40
    drawer.drawGrid grid
