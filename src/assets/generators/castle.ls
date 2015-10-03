define [
    'structures/grid'
    'structures/doubly_linked_list'
    'structures/visited_list'
    'cell/fixture'
    'cell/ground'
    'structures/vec2'
    'structures/direction'
], (Grid, DoublyLinkedList, VisitedList, Fixture, Ground, Vec2, Direction) ->
 
    class Endpoint
        (@cell) ->

    pushParentsReverse = (start, array) ->
        if start?
            pushParentsReverse(start.getParent(), array)
            array.push(start)
    
    pushParents = (start, array) ->
        if start?
            array.push(start)
            pushParentsReverse(start.getParent(), array)

    class CastleGenerator

        findNearestEndpointPair: (endpoint_cells, grid, directions = Direction.Directions) ->

            closest_outer = void
            closest_inner = void

            for e in endpoint_cells
                e.root = e

            queue = DoublyLinkedList.fromArray(endpoint_cells)
            visited = new VisitedList()

            until queue.empty()
                current = queue.dequeue()

                if current.isVisited()
                    continue

                current.setFixture(Fixture.e)

                current.visit()

                for d in directions
                    n = current.neighbours[d]
                    if n?
                        if not n.isVisited()
                            n.setParent(current)
                            n.root = current.root
                            queue.enqueue(n)
                            visited.mark(n)
                        else
                            if n.root != current.root
                                closest_inner = [current, n]
                                closest_outer = [current.root, n.root]
                                break
                if closest_inner?
                    break

            path = void
            for c in closest_inner
                c.setFixture(Fixture.c)
            for c in closest_outer
                c.setFixture(Fixture.d)
            if closest_inner?
                path = []
                pushParentsReverse(closest_inner[0], path)
                pushParents(closest_inner[1], path)

            for c in path
                c.setFixture(Fixture.f)

            visited.unmarkAll(['root'])

        generateGrid: (T, width, height) ->
            grid = new Grid(T, width, height)

            grid.forEach (c) ->
                c.setFixture(Fixture.a)
                c.setGround(Ground.Stone)

            endpoints = grid.getRandomArray(10).map (c) -> new Endpoint(c)

            for e in endpoints
                e.cell.setFixture(Fixture.b)

            @findNearestEndpointPair((endpoints.map (.cell)), grid, Direction.CardinalDirections)

            return grid
        
        getStartingPointHint: ->
            return new Vec2(0, 0)
