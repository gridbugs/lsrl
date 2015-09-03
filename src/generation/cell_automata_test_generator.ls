define [
    'cells/fixture'
    'cells/ground'
    'structures/grid'
    'cells/cell'
    'util'
    'types'
    'debug'
    'structures/direction'
    'input/user_interface'
    'prelude-ls'
], (Fixture, Ground, Grid, Cell, Util, Types, Debug, Direction, UserInterface, Prelude) ->

    const filter = Prelude.filter
    const map = Prelude.map
    const each = Prelude.each

    const OPEN_SPACE_RATIO = 0.4

    class CACell
        (x, y) ->
            @x = x
            @y = y
            @alive = Math.random() < 0.5
            @alive_next = @alive

        step: ->
            @alive = @alive_next

        toString: -> if @alive then " " else @groupIdx

        countAliveNeighbours: -> @allNeighbours |> filter (.alive) |> (.length)

    class CellAutomataTestGenerator

        tryGenerateGrid: (x, y) ->
            @ca_grid = new Grid.Grid(CACell, x, y)

            for i from 0 to 4
                @step 4, 8, 5, 5

            @clean()

            @classifySpaces()

        generateGrid: (T, x, y) ->

            while true
                @tryGenerateGrid x, y
                if @maxSpace.length >= (x*y*OPEN_SPACE_RATIO)
                    break

            game_grid = new Grid.Grid T, x, y
            game_grid.forEach (c, i, j) ~>
                c.setGround Ground.Dirt
                if @ca_grid.get(i, j).alive
                    c.setFixture Fixture.Wall
                else
                    c.setFixture Fixture.Null

            @maxGridSpace = @maxSpace |> map (x)~>game_grid.getCart x

            return game_grid

        getStartingPointHint: -> Util.getRandomElement @maxGridSpace

        clean: ->
            @ca_grid.forEach (c) ->
                count = c.countAliveNeighbours!
                if count > 5
                    c.alive = true
                if count < 2
                    c.alive = false

        step: (live_min, live_max, res_min, res_max) ->
            @ca_grid.forEach (c) ->

                if c.distanceToEdge == 0
                    c.alive_next = true
                    return

                count = c.countAliveNeighbours!

                if c.alive and (count < live_min or count > live_max)
                    c.alive_next = false

                if not c.alive and count >= res_min and count <= res_max
                    c.alive_next = true

            @ca_grid.forEach (.step!)

        floodFillClassify: (c) ->
            @spaces[@currentGroupIdx].push c
            c.groupIdx = @currentGroupIdx
            for n in c.allNeighbours
                if not n.alive and not n.groupIdx?
                    @floodFillClassify n

        classifySpaces: ->
            @spaces = []
            @currentGroupIdx = 0

            @ca_grid.forEach (c) ~>
                if not c.alive and not c.groupIdx?
                    @spaces[@currentGroupIdx] = []
                    @floodFillClassify c
                    ++@currentGroupIdx

            max_space_length = 0
            max_space = void
            for s in @spaces
                if s.length > max_space_length
                    max_space_length = s.length
                    max_space = s
            @maxSpace = max_space

    class RoomSide
        (@room, @cells, @outwardsDirection) ->
            @innerCells = @cells[1 til @cells.length - 1]
            entrance_offset = Direction.Vectors[@outwardsDirection].multiply(2)

            @entranceCandidates = []
            for c in @innerCells
                Util.printDebug c
                coord = c.position.add(entrance_offset)
                if coord.x > 0 and coord.x < @room.grid.width - 1 and coord.y > 0 and coord.y < @room.grid.height - 1
                    Util.printDebug coord
                    @entranceCandidates.push(@room.grid.getCart(coord))

    class Room
        (@width, @height) ->

        finalize: (@grid, @x, @y) ->
            @sides = [
                new RoomSide(this, ([@x til @x + @width] |> map (i) ~> @grid.get(@x + i, @y)), Types.Direction.North)
                new RoomSide(this, ([@y til @y + @height] |> map (i) ~> @grid.get(@x, @y + i)), Types.Direction.West)
                new RoomSide(this, ([@x til @x + @width] |> map (i) ~> @grid.get(@x + i, @y + @height - 1)), Types.Direction.South)
                new RoomSide(this, ([@y til @y + @height] |> map (i) ~> @grid.get(@x + @width - 1, @y + i)), Types.Direction.East)
            ]

            @cells = []
            for i from 0 til @height
                for j from 0 til @width
                    c = @grid.get(@x + j, @y + i)
                    @cells.push(c)
                    c.room = this

            @entranceCandidates = []
            for s in @sides
                for c in s.entranceCandidates
                    @entranceCandidates.push(c)



    Room.createRandom = (min, max) ->
        new Room(Util.getRandomInt(min, max), Util.getRandomInt(min, max))

    class CellAutomataTestGeneratorRooms extends CellAutomataTestGenerator

        generateGrid: (T, x, y) ->
            grid = super(T, x, y)
            for s in @spaces
                if s != @maxSpace
                    for c in s
                        grid.getCart(c).setFixture Fixture.Wall

            @rooms = []

            for i from 0 til 100

                room = Room.createRandom(4, 14)

                for j from 0 til 20
                    x_coord = Util.getRandomInt(0, x - room.width)
                    y_coord = Util.getRandomInt(0, y - room.height)

                    if @roomValidAtPosition(grid, room, x_coord, y_coord)
                        @clearRoomAtPosition(grid, room, x_coord, y_coord)
                        room.finalize(grid, x_coord, y_coord)
                        @rooms.push(room)
                        break

            return grid

        clearRoomAtPosition: (grid, room, x, y) ->
            for i from 0 til room.height
                for j from 0 til room.width
                    c = grid.get(j + x, i + y)
                    Debug.assert(c.fixture.type == Types.Fixture.Wall)
                    c.setFixture(Fixture.Null)

        roomValidAtPosition: (grid, room, x, y) ->
            for i from 0 til room.height
                for j from 0 til room.width
                    c = grid.get(j + x, i + y)
                    if c.fixture.type != Types.Fixture.Wall
                        return false
                    for n in c.neighbours
                        if not n? or n.fixture.type != Types.Fixture.Wall
                            return false

            return true


    {
        CellAutomataTestGenerator
        CellAutomataTestGeneratorRooms
    }
