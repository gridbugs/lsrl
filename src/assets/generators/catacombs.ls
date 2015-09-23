define [
    'structures/grid'
    'structures/vec2'
    'structures/linked_list'
    'cell/fixture'
    'cell/ground'
    'util'
    'types'
], (Grid, Vec2, LinkedList, Fixture, Ground, Util, Types) ->

    RoomCellType = Util.enum [
        \Free
        \Wall
        \Floor
        \Door
        \GroupMember
    ]

    class RoomCell
        (@x, @y) ->
            @position = new Vec2(@x, @y)
            @type = RoomCellType.Free
            @groups = new LinkedList()

        addGroup: (group) ->
            node = group.cells.insert(this)
            @groups.insert({node, group})

    class UniformCellGroup
        ->
            @cells = new LinkedList()
            @min = 0
            @max = 1
            @originalIdentifier = void

    class Room
        (@width, @height) ->
            @grid = new Grid(RoomCell, @width, @height)
            @cellGroups = []

        flipDiagonal: ->
            @grid = @grid.flipDiagonal()


    class RectangularRoomGenerator
        (@min, @max, @doorsMin = 2, @doorsMax = 5) ->

        getRoom: ->
            room = new Room(Util.getRandomInt(@min, @max), Util.getRandomInt(@min, @max))
            room.grid.forEach (cell) ->
                cell.type = RoomCellType.Floor

            door_candidates = []
            room.grid.forEachBorder (cell) ->
                cell.type = RoomCellType.Wall
                if not room.grid.isCornerCell(cell)
                    door_candidates.push(cell)

            num_doors = Util.getRandomInt(@doorsMin, @doorsMax)
            for i from 0 til num_doors
                door_cell = Util.getRandomElement(door_candidates)
                door_cell.type = RoomCellType.Door

            return room

        

    class StringRoomGenerator
        (@stringArray) ->

        getRoom: ->
            room = new Room(@stringArray[0].length, @stringArray.length)

            group_table = {}

            @stringArray.map (string, i) ~>
                string.split('').map (char, j) ~>
                    type = StringRoomGenerator.roomCellTypeFromChar(char)
                    cell = room.grid.get(j, i)
                    cell.type = type
                    if type == RoomCellType.GroupMember
                        if not group_table[char]?
                            group_table[char] = new UniformCellGroup()
                            group_table[char].originalIdentifier = char
                        cell.addGroup(group_table[char])

            for k, v of group_table
                room.cellGroups.push(v)

            if Math.random() > 0.5
                room.flipDiagonal()
            return room

    StringRoomGenerator.roomCellTypeFromChar = (char) ->
        return switch char
            | '?' => RoomCellType.Free
            | '#' => RoomCellType.Wall
            | '.' => RoomCellType.Floor
            | '+' => RoomCellType.Door
            | _   => RoomCellType.GroupMember




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

                if not @intermediate_grid.isValidCoordinate(global_x, global_y)
                    return false

                global_cell = @intermediate_grid.get(global_x, global_y)

                if not (global_cell.type == RoomCellType.Free or
                        global_cell.type == room_cell.type)

                    return false

                if room_cell.type == RoomCellType.GroupMember and
                    @intermediate_grid.getDistanceToEdge(global_cell) < 2

                    return false


        placeRoom: (room, position) ->
            room.grid.forEach (room_cell, room_x, room_y) !~>
                global_x = position.x + room_x
                global_y = position.y + room_y
                global_cell = @intermediate_grid.get(global_x, global_y)
                global_cell.type = room_cell.type

        flatten: ->
            @intermediate_grid.forEach (int_cell, x, y) !~>

                main_cell = @grid.get(x, y)

                fixture = switch int_cell.type
                | RoomCellType.Free => void
                | RoomCellType.Wall => @wallType
                | RoomCellType.Floor => Fixture.Null
                | RoomCellType.Door => @doorType
                | RoomCellType.GroupMember => Fixture.Null

                if fixture?
                    main_cell.setFixture(fixture)

                ground = switch int_cell.type
                | RoomCellType.GroupMember => Ground.Moss

                if ground?
                    main_cell.setGround(ground)

        placeRooms: (attempts) ->
            for i from 0 til attempts
                pos = @intermediate_grid.getRandomCoordinate()
                gen = Util.getRandomElement(@generators)
                room = gen.getRoom()
                if @canPlaceRoom(room, pos)
                    @placeRoom(room, pos)

        generateGrid: (T, width, height) ->
            @intermediate_grid = new Grid(RoomCell, width, height)
            @grid = new Grid(T, width, height)
            @grid.forEach (cell) !->
                cell.setFixture(Fixture.Tree)
                cell.setGround(Ground.Stone)

            @roomPlacementAttempts = 100

            r1 = new R1()
            r2 = new R2()
            r3 = new RectangularRoomGenerator(5, 10)
            
            @generators = [r1, r2, r3, r3, r3, r3]
            @placeRooms(@roomPlacementAttempts)
            
            @flatten()

            return @grid

        getStartingPointHint: ->
            while true
                c = @grid.getRandom()
                if c.fixture.type == Types.Fixture.Null
                    return c
