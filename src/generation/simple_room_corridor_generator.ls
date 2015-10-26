define [
    'structures/grid'
    'structures/doubly_linked_list'
    'structures/visited_list'
    'structures/search'
    'structures/connection_tracker'
    'assets/features/features'
    'cell/ground'
    'structures/vec2'
    'structures/direction'
    'generation/base_generator'
    'util'
    'types'
], (Grid, DoublyLinkedList, VisitedList, Search, ConnectionTracker,
    Feature, Ground, Vec2, Direction, Generator, Util, Types) ->

    FREE = "free"
    ROOM_WALL = "room_wall"
    HALLWAY_WALL = "hallway_wall"
    ENDPOINT_CANDIDATE = "endpoint_candidate"
    DOOR_CANDIDATE = "door_candidate"
    DOOR = "door"
    FLOOR = "floor"
    DEBUG_A = "a"
    DEBUG_B = "b"
    DEBUG_C = "c"
    DEBUG_D = "d"


    pushParentsReverse = (start, array) ->
        if start?
            pushParentsReverse(start.getParent(), array)
            array.push(start)

    pushParents = (start, array) ->
        if start?
            array.push(start)
            pushParentsReverse(start.getParent(), array)

    class SimpleRoomCorridorGenerator extends Generator
        ->
            @charPolicy = {
                '?': FREE
                '#': ROOM_WALL
                '+': DOOR
                'x': DOOR_CANDIDATE
                '%': ENDPOINT_CANDIDATE
                '.': FLOOR
            }

        forPathBetweenCells: (p, q, callback) ->
            result = Search.findPath p
                , /* cost */(c, d, straight_distance) ->
                    return 1000 - (straight_distance * 0.001)
                , /* can enter */(c) ->
                    return c.type == FREE or c.type == ENDPOINT_CANDIDATE
                , q, Direction.CardinalDirections

            if result?
                callback(p)
                for c in result.path
                    callback(c)
                return true
            return false


        findNearestEndpointPair: (endpoint_cells, grid, max_path = 2, directions = Direction.CardinalDirections) ->
            done = false

            for e in endpoint_cells
                e.root = e
                e.visit()

            queue = DoublyLinkedList.fromArray(endpoint_cells)
            visited = new VisitedList()

            until queue.empty()
                current = queue.dequeue()

                if current.type == ROOM_WALL or current.type == FLOOR
                    continue

                for d in directions
                    n = current.neighbours[d]
                    if n?
                        if not n.isVisited() and not n.root? and n.type != ROOM_WALL and n.type != HALLWAY_WALL
                            n.setParent(current)
                            n.root = current.root
                            queue.enqueue(n)
                            current.visit()
                            visited.mark(n)
                        else if n.root != current.root and n.root? and not (n.root.connected or current.root.connected) and
                                (n.root.room != current.root.room) and
                                @connections.getDistance(n.root.room, current.root.room) > max_path

                            if @addHallwayBetweenCells(n.root, current.root)
                                n.root.type = DOOR_CANDIDATE
                                current.root.type = DOOR_CANDIDATE
                                n.root.connected = true
                                current.root.connected = true

                                @connect(n.root.room, current.root.room)

                                break

            visited.unmarkAll(['root', 'connected'])

        addHallwayBetweenCells: (p, q) ->
            return @forPathBetweenCells p, q, (cell) ->
                cell.type = FLOOR
                for n in cell.allNeighbours
                    if n.type == FREE
                        n.type = HALLWAY_WALL

        canAddRectangularRoom: (grid, x, y, width, height, padding) ->
            for i from y - padding til y + height + padding
                for j from x - padding til x + width + padding
                    if not (i < 0 or j < 0 or i >= grid.height or j >= grid.width)
                        if grid.get(j, i).type != FREE
                            return false

                    if i + padding < 0 or i - padding >= grid.height or
                        j + padding < 0 or j - padding >= grid.width
                        return false
            return true

        addRectangularRoom: (grid, x, y, width, height, id) ->
            for i from y til y + height
                for j from x til x + width
                    cell = grid.get(j, i)
                    cell.room = id
                    if (i == y or i == y + height - 1) and
                        (j == x or j == x + width - 1)
                        cell.type = ROOM_WALL
                    else if i == y or i == y + height - 1 or  j == x or j == x + width - 1
                        cell.type = ENDPOINT_CANDIDATE
                    else
                        cell.type = FLOOR

        tryAddRectangularRoom: (grid, x, y, width, height, padding) ->
            if @canAddRectangularRoom(grid, x, y, width, height, padding)
                @addRectangularRoom(grid, x, y, width, height, @numRooms)
                ++@numRooms
                return true
            return false

        canAddCustomRoom: (grid, x, y, string_array) ->
            ret = true
            string_array.map (string, i) ~>
                string.split('').map (char, j) ~>
                    if x + j < 0 or y + i < 0 or x + j >= grid.width or y + i >= grid.height
                        ret := false
                        return
                    type = @charPolicy[char]
                    cell = grid.get(x + j, y + i)
                    if cell.type != FREE and type != FREE
                        ret := false

            return ret

        addCustomRoom: (grid, x, y, string_array, id) ->
            string_array.map (string, i) ~>
                string.split('').map (char, j) ~>
                    type = @charPolicy[char]
                    cell = grid.get(x + j, y + i)
                    if type? and type != FREE
                        cell.type = type
                        cell.room = id

        tryAddCustomRoom: (grid, x, y, string_array) ->
            if @canAddCustomRoom(grid, x, y, string_array)
                @addCustomRoom(grid, x, y, string_array, @numRooms)
                ++@numRooms
                return true
            return false

        translateTypes: (grid, room_door_prob = 0.6, door_prob = 0.9) ->

            has_doors = [Math.random() < room_door_prob for _ from 0 til @numRooms]

            grid.forEach (cell) ->
                feature = switch cell.type
                |   FREE => Feature.Wall
                |   ROOM_WALL, HALLWAY_WALL => Feature.Wall
                |   ENDPOINT_CANDIDATE => Feature.Wall
                |   FLOOR => Feature.Null
                |   DOOR => Feature.Door
                |   DOOR_CANDIDATE =>
                    if has_doors[cell.room] and Math.random() < door_prob
                        Feature.Door
                    else
                        Feature.Null
                |   DEBUG_A => Feature.a
                |   DEBUG_B => Feature.b
                |   DEBUG_C => Feature.c
                |   DEBUG_D => Feature.d

                if feature?
                    cell.feature = new feature()

        getEndpointCandidates: (grid) ->
            candidates = []
            grid.forEach (cell) ->
                if cell.type == ENDPOINT_CANDIDATE
                    candidates.push(cell)
            return candidates

        connect: (x, y) ->
            @connections.connect(x, y)

        rotateRoomStringArrayClockwise: (string_array) ->

            ret = []
            for i from 0 til string_array[0].length
                ret[i] = []

            for i from 0 til string_array.length
                string = string_array[i]
                for j from 0 til string.length
                    ret[j][string_array.length - i - 1] = string[j]

            for i from 0 til ret.length
                ret[i] = ret[i].join('')

            return ret

        rotateRoomStringArrayRandom: (string_array) ->
            for i from 0 til Util.getRandomInt(0, 4)
                string_array = @rotateRoomStringArrayClockwise(string_array)
            return string_array

        generateGrid: (T, width, height) ->
            grid = new Grid(T, width, height)

            grid.forEach (c) ->
                c.ground = new Ground.Stone()
                c.type = FREE

            @numRooms = 0

            return grid

        preConnect: ->
            @connections = new ConnectionTracker(@numRooms)
