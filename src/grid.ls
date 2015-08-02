define [\direction, 'prelude-ls'], (direction, prelude) ->

    map = prelude.map
    join = prelude.join
    filter = prelude.filter

    class Grid
        (T, @width, @height) ->

            @array =
                for i from 0 til height
                    for j from 0 til width
                        new T j, i

            /* Link adjacent cells */
            @__linkNeighbours!

        __linkNeighbours: ->
            @forEach (c) ~>
                c.neighbours = [void] * direction.N_DIRECTIONS
                if c.x > 0
                    c.neighbours[direction.Indices.WEST] = @array[c.y][c.x-1]
                    if c.y > 0
                        c.neighbours[direction.Indices.NORTHWEST] = @array[c.y-1][c.x-1]
                    if c.y < @height - 1
                        c.neighbours[direction.Indices.SOUTHWEST] = @array[c.y+1][c.x-1]
                if c.x < @width - 1
                    c.neighbours[direction.Indices.EAST] = @array[c.y][c.x+1]
                    if c.y > 0
                        c.neighbours[direction.Indices.NORTHEAST] = @array[c.y-1][c.x+1]
                    if c.y < @height - 1
                        c.neighbours[direction.Indices.SOUTHEAST] = @array[c.y+1][c.x+1]
                if c.y > 0
                    c.neighbours[direction.Indices.NORTH] = @array[c.y-1][c.x]
                if c.y < @height - 1
                    c.neighbours[direction.Indices.SOUTH] = @array[c.y+1][c.x]
                
                c.allNeighbours = c.neighbours |> filter (?)
                c.distanceToEdge = Math.min c.x, c.y, (@width - c.x - 1), (@height - c.y - 1)

        forEach: (f) ->
            @array.forEach (row, r_idx, grid) ~>
                row.forEach (cell, c_idx, row) ~>
                    f(cell, c_idx, r_idx, this)

        forEachBorder: (f) ->
            for i from 0 til @width
                f @array[0][i]
            for i from 1 til @height-1
                f @array[i][@width-1]
            for i from (@width-1) to 0 by -1
                f @array[@height-1][i]
            for i from @height-2 til 0 by -1
                f @array[i][0]

        get: (x, y) -> @array[y][x]
        getCart: (c) -> @get c.x, c.y

        toString: -> @array |> map (join '') |> join "\n"

    { Grid }
