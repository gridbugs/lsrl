define [
    'structures/spread'
    'types'
], (Spread, Types) ->

    class Path
        terminateBefore: (predicate) ->
            old_cells = @cells
            @cells = []
            for c in old_cells
                if predicate(c)
                    break
                @cells.push(c)
        

    class StraightLinePath extends Path
        (@start, @end) ->
            if @start.x < @end.x
                x_direction = Types.Direction.East
            else
                x_direction = Types.Direction.West

            if @start.y < @end.y
                y_direction = Types.Direction.South
            else
                y_direction = Types.Direction.North

            x_dist = Math.abs(@start.x - @end.x)
            y_dist = Math.abs(@start.y - @end.y)

            @directions = Spread.spread(x_direction, y_direction, x_dist, y_dist)
            @cells = []
            cell = @start
            for d in @directions
                cell = cell.neighbours[d]
                @cells.push(cell)

    Path.StraightLinePath = StraightLinePath

    return Path
