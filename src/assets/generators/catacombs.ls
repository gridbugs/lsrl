define [
    'structures/grid'
    'structures/vec2'
    'structures/linked_list'
    'cell/fixture'
    'cell/ground'
    'structures/direction'
    'structures/square_table'
    'util'
    'types'
    'debug'
], (Grid, Vec2, LinkedList, Fixture, Ground, Direction, SquareTable, Util, Types, Debug) ->

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

        resetCandidateTypes: ->
            @candidateTypes = Object.keys(RoomCellType).map -> false

        isConnectable: ->
            return @connectable != ConnectableType.Impossible

        connect: ->

            for i from 0 til @candidateTypes.length
                if @candidateTypes[i]
                    @type = i
                    @resetCandidateTypes()
                    return

            Debug.assert(false, 'no candidate')

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
        (@stringArray) ->

        getRoom: ->
            room = new Room(@stringArray[0].length, @stringArray.length)

            @stringArray.map (string, i) ~>
                string.split('').map (char, j) ~>
                    type = StringRoomGenerator.roomCellTypeFromChar(char)
                    cell = room.grid.get(j, i)
                    cell.type = type


            if Math.random() > 0.5
                room.flipDiagonal()
            return room

    StringRoomGenerator.roomCellTypeFromChar = (char) ->
        return switch char
            | '?' => RoomCellType.Free
            | '#' => RoomCellType.Wall
            | '.' => RoomCellType.Floor
            | '+' => RoomCellType.Door




    class R1 extends StringRoomGenerator
        ->
            super([
                \?????????????????????
                \???????#######???????
                \?????###.....###?????
                \???###.........###???
                \?###.............###?
                \##.................##
                \#...................#
                \#...................#
                \#...................#
                \#...................#
                \#...................#
                \#.......##+##.......#
                \#......###.###......#
                \##....####.####....##
                \?#########a#########?
            ])

    class R2 extends StringRoomGenerator
        ->
            super([
                \???a???????????a???
                \###+###?????###+###
                \#.....#?????#.....#
                \#.....#?????#.....#
                \#.....#?????#.....#
                \#.....#######.....b
                \#.....#.....#.....b
                \#.....+.....+.....b
                \#.....#.....#.....b
                \#.....#######.....b
                \#.....#?????#.....#
                \#.....#?????#.....#
                \#.....#?????#.....#
                \###+###?????###+###
                \???a???????????a???
            ])


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

                if not (global_cell.type == RoomCellType.Free or
                        room_cell.type == RoomCellType.Free or
                        global_cell.type == room_cell.type)

                    return false

                if room_cell.type == RoomCellType.GroupMember and
                    @intermediateGrid.getDistanceToEdge(global_cell) < 2

                    return false

                if room_cell.connectable == ConnectableType.Mandatory and
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
                else
                    for i from 0 til global_cell.candidateTypes.length
                        global_cell.candidateTypes[i] =  room_cell.candidateTypes[i]
                     
                if room_cell.type != RoomCellType.Free
                    global_cell.type = room_cell.type


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
                    @spaceAdjacency.set(x, y, true)
                    ++@exitCount[x]
                    ++@exitCount[y]
                    

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
                    cells[0].type = RoomCellType.Floor
                    cells[1].type = RoomCellType.Floor
                    @spaceAdjacency.set(x, y, true)
                    ++@exitCount[x]
                    ++@exitCount[y]

        flatten: ->
            @intermediateGrid.forEach (int_cell, x, y) !~>

                main_cell = @grid.get(x, y)

                fixture = switch int_cell.type
                | RoomCellType.Free => void
                | RoomCellType.Wall => @wallType
                | RoomCellType.Floor => Fixture.Null
                | RoomCellType.Door => @doorType

                #if int_cell.isConnectable()
                #    fixture = Fixture.BrickWall

                if fixture?
                    main_cell.setFixture(fixture)

        placeRooms: (attempts) ->
            for i from 0 til attempts
                pos = @intermediateGrid.getRandomCoordinate()
                gen = Util.getRandomElement(@generators)
                room = gen.getRoom()
                if @canPlaceRoom(room, pos)
                    @placeRoom(room, pos)

        generateGrid: (T, width, height) ->
            @intermediateGrid = new Grid(RoomCell, width, height)
            @grid = new Grid(T, width, height)
            @grid.forEach (cell) !->
                cell.setFixture(Fixture.Tree)
                cell.setGround(Ground.Stone)

            @roomPlacementAttempts = 100

            r1 = new R1()
            r2 = new R2()
            r3 = new RectangularRoomGenerator(8, 12)
            
            @generators = [r3, r3, r3, r3]
            @placeRooms(@roomPlacementAttempts)
            
            @classifySpaces()

            @exitCount = [0] * @numSpaces

            @connectAdjacentRooms()
            @connectAlmostAdjacentRooms()

            @flatten()

            return @grid

        getStartingPointHint: ->
            while true
                c = @grid.getRandom()
                if c.fixture.type == Types.Fixture.Null
                    return c
