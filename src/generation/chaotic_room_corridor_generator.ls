define [
    'structures/connection_tracker'
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
], (ConnectionTracker, Grid, Vec2, LinkedList, Fixture, Ground, Direction,
    SquareTable, Search, Util, Types, Debug) ->


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
            @resetCandidateTypes()
            @allowRooms = true
            @connectingSpaces = []
            @corridorCell = void
            @multipleCorridors = false
            @roomCell = void

        getInteriorSpace: ->
            return @getInteriorCell().getSpace()

        getInteriorSpaces: ->
            return @getInteriorCell().getSpaces()

        getInteriorCell: ->
            if @roomCell?
                return @roomCell
            if @corridorCell?
                return @corridorCell

        hasInteriorCell: ->
            return @roomCell? or @corridorCell?

        setInteriorCell: (cell) ->
            @roomCell = cell

        getSpace: ->
            return @connectingSpaces[0]

        setSpace: (space) ->
            @connectingSpaces[0] = space

        hasSpace: ->
            return @connectingSpaces.length != 0

        getSpaces: ->
            return @connectingSpaces

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
        (@stringArray, @description = @getStandardDescription()) ->

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


    class ChaoticRoomCorridorGenerator
        ->

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
                if cell.type == RoomCellType.Floor and not cell.hasSpace()
                    stack = [cell]
                    while stack.length > 0
                        c = stack.pop()
                        c.setSpace(@numSpaces)
                        for n in c.allNeighbours
                            if n.type == RoomCellType.Floor and not n.hasSpace()
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
                        cell.setInteriorCell(room_cell)

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
                            candidate_lists.get(east.getSpace(), west.getSpace()).push(cell)
                        else if north.type == RoomCellType.Floor and south.type == RoomCellType.Floor
                            candidate_lists.get(north.getSpace(), south.getSpace()).push(cell)

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
                                candidate_lists.get(east.getSpace(), west_west.getSpace()).push([cell, west])
                        else if north.type == RoomCellType.Floor and south.type == RoomCellType.Wall and south.isConnectable()
                            south_south = south.neighbours[Types.Direction.South]
                            if south_south? and south_south.type == RoomCellType.Floor
                                candidate_lists.get(north.getSpace(), south_south.getSpace()).push([cell, south])

            candidate_lists.forEach (list, x, y) !~>
                if list.length > 0
                    cells = Util.getRandomElement(list)
                    cells[0].connect()
                    cells[1].connect()
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
                        (@exitCount[room_cell.getSpace()] < 2 or cell.connectable == ConnectableType.Mandatory)
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

        containsDisconnectedSpace: ->
            for i from 0 til @numSpaces
                if @exitCount[i] == 0
                    return true
            return false

        containsDisconnectedMandatoryConnection: ->
            return @intermediateGrid.forEachExitable false, (cell) !~>
                if cell.connectable == ConnectableType.Mandatory
                    return true

        containsMultipleDisjointSpaces: ->
            found = false
            return @intermediateGrid.forEachExitable false, (cell) !->
                if (cell.type == RoomCellType.Floor or
                    cell.type == RoomCellType.Door) and not cell.marked

                    if found
                        return true

                    found := true

                    stack = [cell]
                    while stack.length > 0
                        c = stack.pop()
                        c.marked = true
                        for n in c.allNeighbours
                            if (n.type == RoomCellType.Floor or
                                n.type == RoomCellType.Door) and not n.marked
                                stack.push(n)


    Util.packObject ChaoticRoomCorridorGenerator, {
        RoomCell,
        Room,
        RectangularRoomGenerator,
        StringRoomGenerator,
        RoomCellType,
        ConnectableType
    }

    return ChaoticRoomCorridorGenerator
