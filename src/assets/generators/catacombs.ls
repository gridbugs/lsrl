define [
    'structures/grid'
    'structures/vec2'
    'cell/fixture'
    'cell/ground'
    'util'
    'types'
], (Grid, Vec2, Fixture, Ground, Util, Types) ->

    RoomCellType = Util.enum [
        \Free
        \Wall
        \Floor
        \Door
        \Connection
    ]

    class RoomCell
        (@x, @y) ->
            @position = new Vec2(@x, @y)
            @type = RoomCellType.Free


    class Room 
        (@width, @height) ->
            @grid = new Grid(RoomCell, @width, @height)

    class StringRoomGenerator
        (@stringArray) ->
            @room = new Room(@stringArray[0].length, @stringArray.length)

            @stringArray.map (string, i) ~>
                string.split('').map (char, j) ~>
                    @room.grid.get(j, i).type = \
                        StringRoomGenerator.roomCellTypeFromChar(char)

        getRoom: ->
            return @room

    StringRoomGenerator.roomCellTypeFromChar = (char) ->
        return switch char
            | '?' => RoomCellType.Free
            | '#' => RoomCellType.Wall
            | '.' => RoomCellType.Floor
            | '+' => RoomCellType.Door
            | 'c' => RoomCellType.Connection



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
                \?#########c#########?
            ])

    class R2 extends StringRoomGenerator
        ->
            super([
                \???c???????????c???
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
                \???c???????????c???
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
                | RoomCellType.Connection => Fixture.Null

                if fixture?
                    global_cell.setFixture(fixture)

        generateGrid: (T, width, height) ->
            @grid = new Grid(T, width, height)
            @grid.forEach (cell) ->
                cell.setFixture(Fixture.Tree)
                cell.setGround(Ground.Stone)

            r1 = new R1()
            r2 = new R2()

            @placeRoom(r1.getRoom(), new Vec2(1, 0))
            @placeRoom(r2.getRoom(), new Vec2(8, 14))

            return @grid

        getStartingPointHint: ->
            while true
                c = @grid.getRandom()
                if c.fixture.type == Types.Fixture.Null
                    return c
