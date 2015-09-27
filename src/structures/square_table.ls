define [
    'util'
], (Util) ->

    class SquareTable
        (@size, init = ->) ->
            @array = Util.createArray2dCalling(@size, @size, -> init())

        get: (x, y) ->
            if x <= y
                return @array[y][x]
            else
                return @array[x][y]

        set: (x, y, value) ->
            if x <= y
                @array[y][x] = value
            else
                @array[x][y] = value

        forEach: (callback) !->
            for i from 0 til @size
                for j from 0 til @size
                    callback(@array[i][j], j, i)

        forEachAssoc: (x, callback) !->
            for i from 0 til x
                callback(@array[x][i], i)

            callback(@array[x][x], x)

            for i from x + 1 til @size
                callback(@array[i][x], i)
