define [
    'generation/chaotic_room_corridor_generator'
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
], (RoomCorridorGenerator, ConnectionTracker, Grid, Vec2, LinkedList, Fixture, Ground, Direction,
    SquareTable, Search, Util, Types, Debug) ->

    RectangularRoomGenerator = RoomCorridorGenerator.RectangularRoomGenerator
    StringRoomGenerator = RoomCorridorGenerator.StringRoomGenerator
    RoomCell = RoomCorridorGenerator.RoomCell
    RoomCellType = RoomCorridorGenerator.RoomCellType
    ConnectableType = RoomCorridorGenerator.ConnectableType
    Room = RoomCorridorGenerator.Room

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


    class CatacombsGenerator extends RoomCorridorGenerator

        ->
            @wallType = Fixture.Wall
            @doorType = Fixture.Door

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

                    if c.hasInteriorCell()
                        for s in c.getInteriorSpaces()
                            distance = @spaceConnections.getDistance(s, wall.getInteriorSpace())
                            if not (distance > min_distance)
                                return false
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

            results = @doSearch(wall, start, min_distance, debug)

            if not results?
                if debug
                    console.debug 'no search results'
                return false
 
            if results.path.length > max_length
                if debug
                    console.debug 'too long'
                return false

            space_ids = results.cell.getInteriorCell().getSpaces()

            for c in results.path.concat([start])
                if c.type == RoomCellType.Free or c.type == RoomCellType.Wall
                    c.type = RoomCellType.Floor

                c.connectingSpaces.push(wall.getInteriorCell().getSpace())
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
                            if n.allowRooms
                                n.type = RoomCellType.Wall
                            else
                                n.type = RoomCellType.Floor


                        if n.type == RoomCellType.Wall and Direction.isCardinal(d)
                            n.setInteriorCell(c)
                            n.connectable = ConnectableType.Possible

            for s in space_ids
                @connect(wall.getInteriorCell().getSpace(), s)

            @doorCandidates.push(wall)
            @doorCandidates.push(results.cell)

            return true

        generateGrid: (T, width, height) ->
            do
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
                
                @doorCandidates = []
                
                @addCorridors(15, 1)
                if @containsDisconnectedSpace() or @containsDisconnectedMandatoryConnection()
                    @addCorridors(100, 0)

                Util.shuffleArrayInPlace(@doorCandidates)
                for i from 0 til Util.getRandomInt(8, 20)
                    door = @doorCandidates.pop()
                    door.type = RoomCellType.Door

            while @containsMultipleDisjointSpaces()

            @flatten()

            return @grid

        getStartingPointHint: ->
            while true
                c = @grid.getRandom()
                if c.fixture.type == Types.Fixture.Null
                    return c
