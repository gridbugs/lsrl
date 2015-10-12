define [
    'util'
], (Util) ->

    class GridWindow
        (@offsetX, @offsetY, @width, @height) ->

        setOffsetX: (grid, x) !->
            @offsetX = Util.constrain(0, x, grid.width - @width)
        setOffsetY: (grid, y) !->
            @offsetY = Util.constrain(0, y, grid.height - @height)

        forEach: (grid, f) !->
            array = grid.array
            for i from 0 til @height
                for j from 0 til @width
                    x = j + @offsetX
                    y = i + @offsetY
                    if x < 0 or y < 0 or x >= grid.width or y >= grid.height
                        f(void, i, j)
                    else
                        f(array[y][x], i, j)

        get: (grid, rel_x, rel_y) ->
            x = rel_x + @offsetX
            y = rel_y + @offsetY
            if x < 0 or y < 0 or x >= grid.width or y >= grid.height
                return void
            return grid.get(x, y)
