require! 'prelude-ls': {map, join}
require! './Direction.ls'

class CellInternal
    (x, y) ->
        @x = x
        @y = y
        @neighbours = [void] * Direction.N_DIRECTIONS
        @data = void

    linkNeighbours: (grid) ->
        if @x > 0
            @neighbours[Direction.WEST] = grid.array[@y][@x-1]
            if @y > 0
                @neighbours[Direction.NORTHWEST] = grid.array[@y-1][@x-1]
            if @y < grid.height - 1
                @neighbours[Direction.SOUTHWEST] = grid.array[@y+1][@x-1]
        if @x < grid.width - 1
            @neighbours[Direction.EAST] = grid.array[@y][@x+1]
            if @y > 0
                @neighbours[Direction.NORTHEAST] = grid.array[@y-1][@x+1]
            if @y < grid.height - 1
                @neighbours[Direction.SOUTHEAST] = grid.array[@y+1][@x+1]
        if @y > 0
            @neighbours[Direction.NORTH] = grid.array[@y-1][@x]
        if @y < grid.height - 1
            @neighbours[Direction.SOUTH] = grid.array[@y+1][@x]

    toString: -> "(#{@x}, #{@y}):#{@data}"

export class Grid
    (width, height, initial) ->
        @width = width
        @height = height
        @array =    for i from 0 til height
                        for j from 0 til width
                            new CellInternal j, i

        /* Link adjacent cells */
        @__forEachInternal (c) ~> c.linkNeighbours this

    __forEachInternal: (f) ->
        @array.forEach (row, r_idx, grid) ~>
            row.forEach (cell, c_idx, row) ~>
                f(cell, [r_idx, c_idx], this)

    forEach: (f) -> @__forEachInternal (x) -> f x.data

    toString: -> @array |> map (join ' ') |> join "\n"
