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

    class StringRoomGenerator
        (@stringArray) ->
            @room = new Room(@stringArray[0].length, @stringArray.length)

            group_table = {}

            @stringArray.map (string, i) ~>
                string.split('').map (char, j) ~>
                    type = StringRoomGenerator.roomCellTypeFromChar(char)
                    cell = @room.grid.get(j, i)
                    cell.type = type
                    if type == RoomCellType.GroupMember
                        if not group_table[char]?
                            group_table[char] = new UniformCellGroup()
                            group_table[char].originalIdentifier = char
                        cell.addGroup(group_table[char])

            for k, v of group_table
                @room.cellGroups.push(v)


        getRoom: ->
            return @room

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
                \?#########.#########?
            ])

    class R2 extends StringRoomGenerator
        ->
            super([
                \???.???????????a???
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

        placeRoom: (room, position) ->
            room.grid.forEach (room_cell, room_x, room_y) ~>
                global_x = position.x + room_x
                global_y = position.y + room_y
                global_cell = @grid.get(global_x, global_y)

                fixture = switch room_cell.type
                | RoomCellType.Free => void
                | RoomCellType.Wall => @wallType
                | RoomCellType.Floor => Fixture.Null
                | RoomCellType.Door => @doorType
                | RoomCellType.GroupMember => Fixture.Null

                if fixture?
                    global_cell.setFixture(fixture)

        generateGrid: (T, width, height) ->
            @grid = new Grid(T, width, height)
            @grid.forEach (cell) ->
                cell.setFixture(Fixture.Tree)
                cell.setGround(Ground.Stone)

            r1 = new R1()
            r2 = new R2()
            console.debug(r2)
            @placeRoom(r1.getRoom(), new Vec2(1, 0))
            @placeRoom(r2.getRoom(), new Vec2(8, 14))

            return @grid

        getStartingPointHint: ->
            while true
                c = @grid.getRandom()
                if c.fixture.type == Types.Fixture.Null
                    return c
