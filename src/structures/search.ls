define [
    'structures/heap'
    'structures/direction'
    'util'
    'types'
    'prelude-ls'
], (Heap, Direction, Util, Types, Prelude) ->

    const empty = Prelude.empty

    class SearchResult
        (@cell, @cost, @path, @directions) ->

    class SearchNode
        (@cell, @cost, @direction, @straightDistance) ->

    pushParentsReversed = (path, directions, cell) ->
        if cell.search_parent?
            pushParentsReversed(path, directions, cell.search_parent)
            path.push(cell)
            directions.push(cell.search_direction)

    dijkstraFindClosest = (start_cell, cost_fn, can_enter_predicate, predicate, can_enter_dest = true, direction_candidates = Direction.Directions) ->
        heap = new Heap.Heap (a, b) -> a.cost <= b.cost

        start_cell.search_cost = 0
        marked = [start_cell]

        heap.insert(new SearchNode(start_cell, 0, Types.Direction.North /* arbitrary */, 0))

        found = false
        target = null

        while not heap.empty()
            current_node = heap.pop()
            current_cell = current_node.cell

            if current_cell.search_visited?
                continue
            current_cell.search_visited = true

            can_enter = can_enter_predicate(current_cell)

            if predicate(current_cell) and (not can_enter_dest or can_enter)
                found = true
                target = current_node
                break

            if not can_enter
                continue

            for d in direction_candidates
                neighbour = current_cell.neighbours[d]
                if neighbour?
                    if d == current_node.direction
                        straight_distance = current_node.straightDistance + 1
                    else
                        straight_distance = 0
                    cost = current_node.cost + cost_fn(current_cell, d, straight_distance)
                    existing_cost = neighbour.search_cost
                    if not existing_cost? or cost < neighbour.search_cost
                        neighbour.search_cost = cost
                        neighbour.search_parent = current_cell
                        neighbour.search_direction = d

                        heap.insert(new SearchNode(neighbour, cost, d, straight_distance))

                    if not existing_cost?
                        marked.push(neighbour)

        if not found

            for m in marked
                m.search_cost = void
                m.search_parent = void
                m.search_visited = void
                m.search_direction = void

            return null

        path = []
        directions = []
        pushParentsReversed path, directions, target.cell
        ret = new SearchResult target.cell, target.cost, path, directions

        for m in marked
            m.search_cost = void
            m.search_parent = void
            m.search_visited = void
            m.search_direction = void

        return ret

    dijkstraFindPath = (start_cell, cost_fn, can_enter_predicate, dest_cell) ->
        return dijkstraFindClosest(start_cell, cost_fn, can_enter_predicate, \
            ((cell) -> cell.position.equals(dest_cell.position)), true, Direction.Directions
        )

    {
        findClosest: dijkstraFindClosest
        findPath: dijkstraFindPath
    }
