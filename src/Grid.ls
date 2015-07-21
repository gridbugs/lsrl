require! 'prelude-ls': {map, join, filter}
require! './Direction.ls'

export class Grid
    (T, width, height) ->
        @width = width
        @height = height

        @array =
            for i from 0 til height
                for j from 0 til width
                    new T j, i

        /* Link adjacent cells */
        @__linkNeighbours!

    __linkNeighbours: ->
        @forEach (c) ~>
            c.neighbours = [void] * Direction.N_DIRECTIONS
            if c.x > 0
                c.neighbours[Direction.WEST] = @array[c.y][c.x-1]
                if c.y > 0
                    c.neighbours[Direction.NORTHWEST] = @array[c.y-1][c.x-1]
                if c.y < @height - 1
                    c.neighbours[Direction.SOUTHWEST] = @array[c.y+1][c.x-1]
            if c.x < @width - 1
                c.neighbours[Direction.EAST] = @array[c.y][c.x+1]
                if c.y > 0
                    c.neighbours[Direction.NORTHEAST] = @array[c.y-1][c.x+1]
                if c.y < @height - 1
                    c.neighbours[Direction.SOUTHEAST] = @array[c.y+1][c.x+1]
            if c.y > 0
                c.neighbours[Direction.NORTH] = @array[c.y-1][c.x]
            if c.y < @height - 1
                c.neighbours[Direction.SOUTH] = @array[c.y+1][c.x]

    forEach: (f) ->
        @array.forEach (row, r_idx, grid) ~>
            row.forEach (cell, c_idx, row) ~>
                f(cell, [r_idx, c_idx], this)

    getCell: (x, y) -> @array[y][x]
    getCellCart: (c) -> @getCell c.x, c.y

    toString: -> @array |> map (join '') |> join "\n"
