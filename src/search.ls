define [
    \heap
    \direction
    \util
    'prelude-ls'
], (Heap, Direction, Util, Prelude) ->

    empty = Prelude.empty

    class SearchResult
        (@cell, @cost, @path) ->

    class SearchNode
        (@cell, @cost) ->

    pushParentsReversed = (array, node) ->
        if node.search_parent?
            pushParentsReversed array, node.search_parent
        array.push node

    dijkstraFindClosest = (start_cell, cost_fn, can_enter_predicate, predicate) ->
        heap = new Heap.Heap (a, b) -> a.cost <= b.cost

        start_cell.search_cost = 0
        marked = [start_cell]

        heap.insert new SearchNode(start_cell, 0)

        found = false
        target = null

        while not heap.empty!
            current_node = heap.pop!
            current_cell = current_node.cell

            if current_cell.search_visited?
                continue
            current_cell.search_visited = true

            if predicate(current_cell)
                found = true
                target = current_node
                break

            for d in Direction.AllIndices
                neighbour = current_cell.neighbours[d]
                if neighbour? and can_enter_predicate(neighbour)
                    cost = current_node.cost + cost_fn(current_cell, d)
                    existing_cost = neighbour.search_cost
                    if not existing_cost? or cost < neighbour.search_cost
                        neighbour.search_cost = cost
                        neighbour.search_parent = current_cell
                        heap.insert new SearchNode(neighbour, cost)

                    if not existing_cost?
                        marked.push neighbour

        if not found

            for m in marked
                m.search_cost = void
                m.search_parent = void
                m.search_visited = void

            return null

        path = []
        pushParentsReversed path, target.cell
        ret = new SearchResult target.cell, target.cost, path

        for m in marked
            m.search_cost = void
            m.search_parent = void
            m.search_visited = void

        return ret

    {
        findClosest: dijkstraFindClosest
    }
