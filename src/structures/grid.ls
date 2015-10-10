define [
    'structures/direction'
    'structures/grid_window'
    'types'
    'structures/vec2'
    'util'
    'prelude-ls'
], (Direction, GridWindow, Types, Vec2, Util, Predule) ->

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
            f(@array[0][0], Types.Direction.NorthWest)

            # north
            for i from 1 til @width - 1
                f(@array[0][i], Types.Direction.North)

            # north east corner
            f(@array[0][@width - 1], Types.Direction.NorthEast)

            # east
            for i from 1 til @height-1
                f(@array[i][@width-1], Types.Direction.East)

            # south east corner
            f(@array[@height - 1][@width - 1], Types.Direction.SouthEast)

            # south
            for i from @width-2 to 1 by -1
                f(@array[@height-1][i], Types.Direction.South)

            # south west corner
            f(@array[@height - 1][0], Types.Direction.SouthWest)

            # west
            for i from @height-2 til 0 by -1
                f(@array[i][0], Types.Direction.West)

        forEachBorderAtDepth: (d, f) ->
            # north west corner
            f(@array[d][d], Types.Direction.NorthWest)

            # north
            for i from 1 + d til @width - 1 - d
                f(@array[d][i], Types.Direction.North)

            # north east corner
            f(@array[d][@width - 1 - d], Types.Direction.NorthEast)

            # east
            for i from 1 + d til @height - 1 - d
                f(@array[i][@width - 1 - d], Types.Direction.East)

            # south east corner
            f(@array[@height - 1 - d][@width - 1 - d], Types.Direction.SouthEast)

            # south
            for i from @width - 2 - d to 1 + d by -1
                f(@array[@height - 1 - d][i], Types.Direction.South)

            # south west corner
            f(@array[@height - 1 - d][d], Types.Direction.SouthWest)

            # west
            for i from @height - 2 - d til d by -1
                f(@array[i][d], Types.Direction.West)

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

        asArray: ->
            ret = []
            @forEach (cell) ->
                ret.push(cell)
            return ret

        asArrayWhere: (p) ->
            return @asArray().filter(p)

        getRandomArray: (length) ->
            ret = @asArray()
            Util.shuffleArrayInPlace(ret)
            return ret.slice(0, length)

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

        getWindow: (x, y, width, height) ->
            return new GridWindow(this, x, y, width, height)
