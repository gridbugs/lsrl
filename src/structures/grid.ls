define [
    'structures/direction'
    'types'
    'structures/vec2'
    'prelude-ls'
], (Direction, Types, Vec2, Predule) ->

    const map = Predule.map
    const join = Predule.join
    const filter = Predule.filter

    class Grid
        (@T, @width, @height) ->

            @array =
                for i from 0 til height
                    for j from 0 til width
                        new @T j, i

            /* Link adjacent cells */
            @__linkNeighbours!

        __linkNeighbours: ->
            @forEach (c) !~>
                c.neighbours = [void] * Direction.NumDirections
                if c.x > 0
                    c.neighbours[Types.Direction.West] = @array[c.y][c.x-1]
                    if c.y > 0
                        c.neighbours[Types.Direction.NorthWest] = @array[c.y-1][c.x-1]
                    if c.y < @height - 1
                        c.neighbours[Types.Direction.SouthWest] = @array[c.y+1][c.x-1]
                if c.x < @width - 1
                    c.neighbours[Types.Direction.East] = @array[c.y][c.x+1]
                    if c.y > 0
                        c.neighbours[Types.Direction.NorthEast] = @array[c.y-1][c.x+1]
                    if c.y < @height - 1
                        c.neighbours[Types.Direction.SouthEast] = @array[c.y+1][c.x+1]
                if c.y > 0
                    c.neighbours[Types.Direction.North] = @array[c.y-1][c.x]
                if c.y < @height - 1
                    c.neighbours[Types.Direction.South] = @array[c.y+1][c.x]

                c.allNeighbours = c.neighbours |> filter (?)
                c.distanceToEdge = Math.min(c.x, c.y, (@width - c.x - 1), (@height - c.y - 1))

        forEach: (f) !->
            for i from 0 til @array.length
                row = @array[i]
                for j from 0 til row.length
                    f(row[j], j, i, this)

        forEachExitable: (def, f) ->
            for i from 0 til @array.length
                row = @array[i]
                for j from 0 til row.length
                    ret = f(row[j], j, i, this)
                    if ret?
                        return ret
            return def

        forEachBorder: (f) ->
            
            # north west corner
            f(@array[0][0])

            # north
            for i from 1 til @width - 1
                f(@array[0][i])

            # north east corner
            f(@array[0][@width - 1])

            # east
            for i from 1 til @height-1
                f(@array[i][@width-1])

            # south east corner
            f(@array[@height - 1][@width - 1])

            # south
            for i from (@width-1) to 1 by -1
                f(@array[@height-1][i])

            # south west corner
            f(@array[@height - 1][0])

            # west
            for i from @height-2 til 0 by -1
                f(@array[i][0])

        isBorderCoordinate: (x, y) ->
            return x == 0 or y == 0 or x == @width - 1 or y == @height - 1

        isBorderCell: (c) ->
            return @isBorderCoordinate(c.x, c.y)

        isCornerCoordinate: (x, y) ->
            return (x == 0 and (y == 0 or y == @height - 1)) or
                   (x == @width - 1 and (y == 0 or y == @height - 1))

        isCornerCell: (c) ->
            return @isCornerCoordinate(c.x, c.y)

        getDistanceToEdge: (c) ->
            return c.distanceToEdge

        isValidCoordinate: (x, y) ->
            return x >= 0 and y >= 0 and x < @width and y < @height

        get: (x, y) ->
            return @array[y][x]
        getCart: (c) ->
            return @get(c.x, c.y)
        getRandom: ->
            return @get(Math.floor(Math.random()*@width), Math.floor(Math.random()*@height))
        getRandomCoordinate: ->
            return new Vec2(Math.floor(Math.random()*@width), Math.floor(Math.random()*@height))

        flipDiagonal: ->
            /* a b c
             * d e f
             *
             * becomes
             *
             * d a
             * e b
             * f c
             *
             */
            ret = new Grid(@T, @height, @width)
            @forEach (cell, x, y) !~>
                ret.array[x][y] = cell
            return ret

        clone: ->
            ret = new Grid(@T, @width, @height)
            @forEach (cell, x, y) !~>
                ret.array[y][x] = cell
            return ret


        toString: -> @array |> map (join '') |> join "\n"
