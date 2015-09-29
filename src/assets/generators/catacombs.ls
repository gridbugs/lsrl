define [
    'structures/grid'
    'structures/vec2'
    'structures/linked_list'
    'cell/fixture'
    'cell/ground'
    'structures/direction'
    'structures/square_table'
    'structures/search'
    'util'
    'types'
    'debug'
], (Grid, Vec2, LinkedList, Fixture, Ground, Direction, SquareTable, Search, Util, Types, Debug) ->

    class ConnectionTracker
        (@size) ->
            @connections = new SquareTable(@size, -> -1)

            for i from 0 til @size
                @connections.set(i, i, 0)

        connect: (i, j) ->

            @connections.forEachAssoc i, (v, k) ~>
                if v != -1
                    existing = @connections.get(j, k)
                    if existing == -1 or v + 1 < existing
                        @connections.set(j, k, v + 1)

            @connections.forEachAssoc j, (v, k) ~>
                if v != -1
                    existing = @connections.get(i, k)
                    if existing == -1 or v + 1 < existing
                        @connections.set(i, k, v + 1)

            # for each vertex that could be connected to i
            @connections.forEachAssoc i, (v, _j) ~>
                # if the vertex is connected to i
                if v != -1
                    # for each vertex that could be connected to j
                    @connections.forEachAssoc j, (u, _i) ~>
                        # if the vertex is connected to j
                        if u != -1
                            existing = @connections.get(_i, _j)
                            if existing  == -1 or  v + u + 1 < existing
                                @connections.set(_i, _j, v + u + 1)

            @connections.set(i, j, 1)

        listConnections: ->
            for i from 0 til @size
                @connections.forEachAssoc i, (v, k) ->
                    if v
                        console.debug i, k

        isConnected: (i, j) ->
            return @connections.get(i, j) != -1

        getDistance: (i, j) ->
            ret = @connections.get(i, j)
            if ret == -1
                return Infinity
            return ret

    RoomCellType = Util.enum [
        \Free
        \Wall
        \Floor
        \Door
    ]

    ConnectableType = Util.enum [
        \Impossible
        \Possible
        \Mandatory
    ]

    class RoomCell
        (@x, @y) ->
            @position = new Vec2(@x, @y)
            @type = RoomCellType.Free
            @connectable = ConnectableType.Impossible
            @spaceId = -1
            @resetCandidateTypes()
            @allowRooms = true
            @connectingSpaces = []
            @corridorCell = void
            @multipleCorridors = false

        resetCandidateTypes: ->
            @candidateTypes = Object.keys(RoomCellType).map -> false

        isConnectable: ->
            return @connectable != ConnectableType.Impossible

        connect: ->
            @connectable = ConnectableType.Impossible
            if @type == RoomCellType.Free or @type == RoomCellType.Wall
                @type = RoomCellType.Floor

    class Room
        (@width, @height) ->
            @grid = new Grid(RoomCell, @width, @height)

        flipDiagonal: ->
            @grid = @grid.flipDiagonal()

    class RectangularRoomGenerator
        (@min, @max, @doorsMin = 2, @doorsMax = 2) ->

        getRoom: ->
            room = new Room(Util.getRandomInt(@min, @max), Util.getRandomInt(@min, @max))
            room.grid.forEach (cell) ->
                cell.type = RoomCellType.Floor

            room.grid.forEachBorder (cell) ->
                cell.type = RoomCellType.Free

            room.grid.forEachBorderAtDepth 1, (cell, direction) ->
                cell.type = RoomCellType.Wall
                cell.connectable = ConnectableType.Impossible
                if Direction.isCardinal(direction)
                    cell.candidateTypes[RoomCellType.Door] = true
                    cell.candidateTypes[RoomCellType.Floor] = true
                    cell.connectable = ConnectableType.Possible

            return room




    class StringRoomGenerator
        (@stringArray, @description) ->

        getRoom: ->
            room = new Room(@stringArray[0].length, @stringArray.length)

            @stringArray.map (string, i) ~>
                string.split('').map (char, j) ~>
                    cell = room.grid.get(j, i)
                    @createCellFromChar(cell, char)


            if Math.random() > 0.5
                room.flipDiagonal()
            return room

        createCellFromChar: (cell, char) ->

            char_desc = @description[char]
            if char_desc?
                cell.type = char_desc.type
                cell.connectable = char_desc.connectable
                if char_desc.allowRooms?
                    cell.allowRooms = char_desc.allowRooms
                return

            type = switch char
                | '?' => RoomCellType.Free
                | '#' => RoomCellType.Wall
                | '.' => RoomCellType.Floor
                | '+' => RoomCellType.Door

            cell.type = type
            if type == RoomCellType.Door
                cell.connectable = ConnectableType.Mandatory
            else
                cell.connectable = ConnectableType.Impossible

        getStandardDescription: ->
            return {
                '#': {type: RoomCellType.Wall, connectable: ConnectableType.Impossible},
                '.': {type: RoomCellType.Floor, connectable: ConnectableType.Impossible},
                '+': {type: RoomCellType.Door, connectable: ConnectableType.Mandatory},
                '?': {type: RoomCellType.Free, connectable: ConnectableType.Possible},
                'a': {type: RoomCellType.Free, connectable: ConnectableType.Possible, allowRooms: false}
            }

    class R1 extends StringRoomGenerator
        ->
            super([
                \??????a??????
                \????##+##????
                \???##...##???
                \??##.....##??
                \?##.......##?
                \?#.........#?
                \a+.........+a
                \?#.........#?
                \?##.......##?
                \??##.....##??
                \???##...##???
                \????##+##????
                \??????a??????
            ], @getStandardDescription())

    class R2 extends StringRoomGenerator
        ->
            super([
                \???a???????????a???
                \###+###?????###+###
                \#.....#?????#.....#
                \#.....#?????#.....#
                \#.....#?????#.....#
                \#.....#######.....#
                \#.....#.....#.....#
                \#.....+.....+.....#
                \#.....#.....#.....#
                \#.....#######.....#
                \#.....#?????#.....#
                \#.....#?????#.....#
                \#.....#?????#.....#
                \###+###?????###+###
                \???a???????????a???
            ], @getStandardDescription())


    class CatacombsGenerator

        ->
            @wallType = Fixture.Wall
            @doorType = Fixture.Door

        canPlaceRoom: (room, position) ->
            return room.grid.forEachExitable true, (room_cell, room_x, room_y) !~>
                global_x = position.x + room_x
                global_y = position.y + room_y

                if not @intermediateGrid.isValidCoordinate(global_x, global_y)
                    return false

                global_cell = @intermediateGrid.get(global_x, global_y)

                if not global_cell.allowRooms and room_cell.type != RoomCellType.Free
                    return false

                if not room_cell.allowRooms and global_cell.type != RoomCellType.Free
                    return false

                if room_cell.type == RoomCellType.Wall and
                    @intermediateGrid.isBorderCell(global_cell)

                    return false

                if room_cell.type == RoomCellType.Door and
                    @intermediateGrid.getDistanceToEdge(global_cell) < 2

                    return false

                if not (global_cell.type == RoomCellType.Free or
                        room_cell.type == RoomCellType.Free or
                        global_cell.type == room_cell.type)

                    return false

                if global_cell.type != RoomCellType.Free and
                    room_cell.connectable == ConnectableType.Mandatory and
                    global_cell.conenctable != ConnectableType.Mandatory

                    return false

                if room_cell.connectable != ConnectableType.Mandatory and
                    global_cell.conenctable == ConnectableType.Mandatory

                    return false


        placeRoom: (room, position) ->
            room.grid.forEach (room_cell, room_x, room_y) !~>
                global_x = position.x + room_x
                global_y = position.y + room_y
                global_cell = @intermediateGrid.get(global_x, global_y)

                if global_cell.type == RoomCellType.Free
                    global_cell.connectable = room_cell.connectable
                else if room_cell.type != RoomCellType.Free
                    if room_cell.connectable == ConnectableType.Impossible
                        global_cell.connectable = ConnectableType.Impossible

                if global_cell.type == RoomCellType.Free
                    for i from 0 til global_cell.candidateTypes.length
                        global_cell.candidateTypes[i] = room_cell.candidateTypes[i]
                else if room_cell.type != RoomCellType.Free
                    for i from 0 til global_cell.candidateTypes.length
                        global_cell.candidateTypes[i] = room_cell.candidateTypes[i] #TODO

                if room_cell.type != RoomCellType.Free
                    global_cell.type = room_cell.type

                global_cell.allowRooms = room_cell.allowRooms


        classifySpaces: ->
            @numSpaces = 0
            @intermediateGrid.forEach (cell) !~>
                if cell.type == RoomCellType.Floor and cell.spaceId == -1
                    stack = [cell]
                    while stack.length > 0
                        c = stack.pop()
                        c.spaceId = @numSpaces
                        for n in c.allNeighbours
                            if n.type == RoomCellType.Floor and n.spaceId == -1
                                stack.push(n)
                    ++@numSpaces
            @spaceAdjacency = new SquareTable(@numSpaces, -> false)
            @spaceConnections = new ConnectionTracker(@numSpaces)

        classifyWalls: ->
            @intermediateGrid.forEach (cell) !~>
                if cell.type == RoomCellType.Wall or cell.type == RoomCellType.Door
                    east = cell.neighbours[Types.Direction.East]
                    west = cell.neighbours[Types.Direction.West]
                    north = cell.neighbours[Types.Direction.North]
                    south = cell.neighbours[Types.Direction.South]

                    count = 0

                    if east.type == RoomCellType.Floor and west.type == RoomCellType.Free
                        room_cell = east
                        ++count

                    if west.type == RoomCellType.Floor and east.type == RoomCellType.Free
                        room_cell = west
                        ++count

                    if north.type == RoomCellType.Floor and south.type == RoomCellType.Free
                        room_cell = north
                        ++count

                    if south.type == RoomCellType.Floor and north.type == RoomCellType.Free
                        room_cell = south
                        ++count

                    if count == 1
                        cell.roomCell = room_cell
                    else
                        cell.roomCell = void




        connect: (x, y) ->
            @spaceAdjacency.set(x, y, true)
            @spaceConnections.connect(x, y)
            ++@exitCount[x]
            ++@exitCount[y]


        connectAdjacentRooms: ->

            candidate_lists = new SquareTable(@numSpaces, -> [])

            @intermediateGrid.forEach (cell) !~>
                if not @intermediateGrid.isBorderCell(cell)
                    if cell.isConnectable()
                        east = cell.neighbours[Types.Direction.East]
                        west = cell.neighbours[Types.Direction.West]
                        north = cell.neighbours[Types.Direction.North]
                        south = cell.neighbours[Types.Direction.South]

                        if east.type == RoomCellType.Floor and west.type == RoomCellType.Floor
                            candidate_lists.get(east.spaceId, west.spaceId).push(cell)
                        else if north.type == RoomCellType.Floor and south.type == RoomCellType.Floor
                            candidate_lists.get(north.spaceId, south.spaceId).push(cell)

            candidate_lists.forEach (list, x, y) !~>
                if list.length > 0
                    cell = Util.getRandomElement(list)
                    cell.connect()
                    @connect(x, y)


        connectAlmostAdjacentRooms: ->

            candidate_lists = new SquareTable(@numSpaces, -> [])

            @intermediateGrid.forEach (cell) !~>
                if not @intermediateGrid.isBorderCell(cell)
                    if cell.isConnectable()
                        east = cell.neighbours[Types.Direction.East]
                        west = cell.neighbours[Types.Direction.West]
                        north = cell.neighbours[Types.Direction.North]
                        south = cell.neighbours[Types.Direction.South]

                        if east.type == RoomCellType.Floor and west.type == RoomCellType.Wall and west.isConnectable()
                            west_west = west.neighbours[Types.Direction.West]
                            if west_west? and west_west.type == RoomCellType.Floor
                                candidate_lists.get(east.spaceId, west_west.spaceId).push([cell, west])
                        else if north.type == RoomCellType.Floor and south.type == RoomCellType.Wall and south.isConnectable()
                            south_south = south.neighbours[Types.Direction.South]
                            if south_south? and south_south.type == RoomCellType.Floor
                                candidate_lists.get(north.spaceId, south_south.spaceId).push([cell, south])

            candidate_lists.forEach (list, x, y) !~>
                if list.length > 0
                    cells = Util.getRandomElement(list)
                    cells[0].connect()
                    cells[1].connect()
                    #cells[0].type = RoomCellType.Floor
                    #cells[1].type = RoomCellType.Floor
                    @connect(x, y)

        flatten: ->
            @intermediateGrid.forEach (int_cell, x, y) !~>

                main_cell = @grid.get(x, y)

                fixture = switch int_cell.type
                | RoomCellType.Free => void
                | RoomCellType.Wall => @wallType
                | RoomCellType.Floor => Fixture.Null
                | RoomCellType.Door => @doorType

                if fixture?
                    main_cell.setFixture(fixture)

        placeRooms: (attempts) ->
            for i from 0 til attempts
                pos = @intermediateGrid.getRandomCoordinate()
                gen = Util.getRandomElement(@generators)
                room = gen.getRoom()
                if @canPlaceRoom(room, pos)
                    @placeRoom(room, pos)

        findCorridorCandidates: ->

            corridor_start_candidates = []
            mandatory_candidates = []

            @intermediateGrid.forEach (cell, x, y) !~>
                if not @intermediateGrid.isBorderCell(cell) and  cell.isConnectable()
                    east = cell.neighbours[Types.Direction.East]
                    west = cell.neighbours[Types.Direction.West]
                    north = cell.neighbours[Types.Direction.North]
                    south = cell.neighbours[Types.Direction.South]

                    if east.type == RoomCellType.Floor and west.type == RoomCellType.Free
                        room_cell = east
                        outer_cell = west

                    if west.type == RoomCellType.Floor and east.type == RoomCellType.Free
                        room_cell = west
                        outer_cell = east

                    if north.type == RoomCellType.Floor and south.type == RoomCellType.Free
                        room_cell = north
                        outer_cell = south

                    if south.type == RoomCellType.Floor and north.type == RoomCellType.Free
                        room_cell = south
                        outer_cell = north

                    if room_cell? and @intermediateGrid.getDistanceToEdge(cell) > 1 and
                        (@exitCount[room_cell.spaceId] < 2 or cell.connectable == ConnectableType.Mandatory)
                        if cell.connectable == ConnectableType.Mandatory
                            mandatory_candidates.push([cell, outer_cell])
                        else
                            corridor_start_candidates.push([cell, outer_cell])

            if mandatory_candidates.length == 0
                Util.shuffleArrayInPlace(corridor_start_candidates)
                return corridor_start_candidates
            else
                Util.shuffleArrayInPlace(mandatory_candidates)
                return mandatory_candidates


        addCorridors: (max_length, min_distance) ->
            candidates = @findCorridorCandidates()
            while candidates.length > 0
                @addCorridor(candidates, min_distance, max_length)

            candidates = @findCorridorCandidates()
            for i from 0 til 10
                @addCorridor(candidates, min_distance + i/4, max_length)

            for i from 0 til 10
                @addCorridor(candidates, min_distance, max_length)

        doSearch: (wall, start, min_distance, debug) ->
            results = Search.findClosest(
                start,
                (c, d, straight_distance) ->
                    return (1 / (straight_distance + 1))
                (c) ~>
                    return c.type == RoomCellType.Free and not @intermediateGrid.isBorderCell(c)
                ,
                (c) ~>
                    if not c.isConnectable()
                        return false
                    room_cell = c.roomCell
                    if room_cell?
                        distance = @spaceConnections.getDistance(room_cell.spaceId, wall.roomCell.spaceId)
                        if distance > min_distance
                            if debug
                                console.debug 'room'
                            return true
                        return false

                    corridor_cell = c.corridorCell
                    if not c.multipleCorridors and corridor_cell?
                        for id in corridor_cell.connectingSpaces
                            distance = @spaceConnections.getDistance(id, wall.roomCell.spaceId)
                            if not (distance > min_distance)
                                return false

                        if debug
                            console.debug 'corridor'
                        return true

                    return false

                , false,
                Direction.CardinalDirections
            )

            return results

        addCorridor: (candidates, min_distance, max_length, debug) ->

            if candidates.length == 0
                if debug
                    console.debug 'no candidates'
                return false

            [wall, start] = candidates.pop() #Util.getRandomElement(candidates)

            #if loops and @exitCount[wall.roomCell.spaceId] > 2
            #    return false


            results = @doSearch(wall, start, min_distance, debug)

            if not results?
                if debug
                    console.debug 'no search results'
                return false
 
            if results.path.length > max_length
                if debug
                    console.debug 'too long'
                return false

            if results.cell.roomCell?
                space_ids = [results.cell.roomCell.spaceId]
            else
                space_ids = results.cell.corridorCell.connectingSpaces

            for c in results.path.concat([start])
                if c.type == RoomCellType.Free or c.type == RoomCellType.Wall
                    c.type = RoomCellType.Floor

                c.connectingSpaces.push(wall.roomCell.spaceId)
                for id in space_ids
                    c.connectingSpaces.push(id)

                if debug
                    console.debug c
                    c.type = RoomCellType.Door

            wall.connect()
            start.connect()
            for c in results.path.concat([start])
                for d in Direction.Directions
                    n = c.neighbours[d]
                    if n?
                        if n.type == RoomCellType.Free
                            n.type = RoomCellType.Wall

                        if n.type == RoomCellType.Wall and Direction.isCardinal(d)
                            n.corridorCell = c
                            n.connectable = ConnectableType.Possible

            for s in space_ids
                @connect(wall.roomCell.spaceId, s)

            return true

        containsDisconnectedSpace: ->
            for i from 0 til @numSpaces
                if @exitCount[i] == 0
                    return true
            return false

        containsDisconnectedMandatoryConnection: ->
            return @intermediateGrid.forEachExitable false, (cell) !~>
                if cell.connectable == ConnectableType.Mandatory
                    return true

        generateGrid: (T, width, height) ->
            @intermediateGrid = new Grid(RoomCell, width, height)
            @grid = new Grid(T, width, height)
            @grid.forEach (cell) !->
                cell.setFixture(Fixture.DirtWall)
                cell.setGround(Ground.Stone)

            @roomPlacementAttempts = 100

            r1 = new R1()
            r2 = new R2()
            r3 = new RectangularRoomGenerator(8, 12)

            @generators = [r1, r2, r3, r3]
            @placeRooms(@roomPlacementAttempts)

            @classifySpaces()

            @classifyWalls()

            @exitCount = [0] * @numSpaces

            @connectAdjacentRooms()
            @connectAlmostAdjacentRooms()
            
            
            @addCorridors(15, 1)
            if @containsDisconnectedSpace() or @containsDisconnectedMandatoryConnection()
                @addCorridors(100, 0)
            
            @flatten()


            return @grid

        getStartingPointHint: ->
            while true
                c = @grid.getRandom()
                if c.fixture.type == Types.Fixture.Null
                    return c
