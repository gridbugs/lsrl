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
                    c.neighbours[direction.Indices.West] = @array[c.y][c.x-1]
                    if c.y > 0
                        c.neighbours[direction.Indices.NorthWest] = @array[c.y-1][c.x-1]
                    if c.y < @height - 1
                        c.neighbours[direction.Indices.SouthWest] = @array[c.y+1][c.x-1]
                if c.x < @width - 1
                    c.neighbours[direction.Indices.East] = @array[c.y][c.x+1]
                    if c.y > 0
                        c.neighbours[direction.Indices.NorthEast] = @array[c.y-1][c.x+1]
                    if c.y < @height - 1
                        c.neighbours[direction.Indices.SouthEast] = @array[c.y+1][c.x+1]
                if c.y > 0
                    c.neighbours[direction.Indices.North] = @array[c.y-1][c.x]
                if c.y < @height - 1
                    c.neighbours[direction.Indices.South] = @array[c.y+1][c.x]

                c.allNeighbours = c.neighbours |> filter (?)
                c.distanceToEdge = Math.min c.x, c.y, (@width - c.x - 1), (@height - c.y - 1)

        forEach: (f) ->
            for i from 0 til @array.length
                row = @array[i]
                for j from 0 til row.length
                    f row[j], j, i, this

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
        getRandom: -> @get Math.floor(Math.random()*@width), Math.floor(Math.random()*@height)

        toString: -> @array |> map (join '') |> join "\n"

    { Grid }
