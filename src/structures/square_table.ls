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
            for i from 0 til @array.length
                for j from 0 til @array[i].length
                    callback(@array[i][j], j, i)
