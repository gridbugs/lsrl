define [
    \util
    'prelude-ls'
], (Util, Prelude) ->

    empty = Prelude.empty

    floodFill = (start_cell, include_start, predicate, callback) ->
        stack = [start_cell]

        start_cell.flood_visited = true
        visited = [start_cell]

        if include_start and predicate(start_cell)
            callback start_cell

        while not empty stack
            cell = stack.pop!
            for n in cell.allNeighbours
                if not n.flood_visited and predicate(n)
                    callback(n)
                    stack.push(n)
                    n.flood_visited = true
                    visited.push(n)

        while not empty visited
            visited.pop!flood_visited = false

    {
        floodFill
    }
