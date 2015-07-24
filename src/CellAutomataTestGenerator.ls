require! 'prelude-ls': {filter, map}
require! './Util.ls': {filterVoid}
require! './Grid.ls': {Grid}
require! './Tiles.ls': {Tiles}

class CACell
    (x, y) ->
        @x = x
        @y = y
        @alive = Math.random() < 0.5
        @alive_next = @alive

    step: ->
        @alive = @alive_next

    toString: -> if @alive then "#" else " "

    countAliveNeighbours: -> @allNeighbours |> filter (.alive) |> (.length)

export class CellAutomataTestGenerator
    generate: (T, x, y) ->
        @ca_grid = new Grid CACell, x, y

        for i from 0 to 4
            @step 4, 8, 5, 5
        
        @clean!
        
        grid = new Grid T, x, y
        grid.forEach (c, i, j) ~>
            if @ca_grid.get(i, j).alive
                c.type = Tiles.WALL
            else
                c.type = Tiles.DIRT
        
        return grid

    clean: ->
        @ca_grid.forEach (c) ->
            count = c.countAliveNeighbours!
            if count > 5
                c.alive = true
            if count < 2
                c.alive = false

    step: (live_min, live_max, res_min, res_max) ->
        @ca_grid.forEach (c) ->

            if c.distanceToEdge == 0
                c.alive_next = true
                return

            count = c.countAliveNeighbours!
            
            if c.alive and (count < live_min or count > live_max)
                c.alive_next = false

            if not c.alive and count >= res_min and count <= res_max
                c.alive_next = true

        @ca_grid.forEach (.step!)

