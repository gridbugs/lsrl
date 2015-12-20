define [
    'generation/simple_room_corridor_generator'
    'types'
    'util'
    'debug'
], (SimpleRoomCorridorGenerator, Types, Util, Debug) ->

    class CastleGenerator extends SimpleRoomCorridorGenerator
        ->
            super()

        generateGrid: (T, width, height, fromConnections, toConnections) ->

            grid = super(T, width, height, fromConnections, toConnections)

            custom_rooms = [
                [
                    \??????*??????
                    \????##%##????
                    \???##...##???
                    \??##.....##??
                    \?##.......##?
                    \?#.........#?
                    \*%.........%*
                    \?#.........#?
                    \?##.......##?
                    \??##.....##??
                    \???##...##???
                    \????##%##????
                    \??????*??????
                ],
                [
                    \**********?????
                    \*##%%%%##*?????
                    \*#......#*?????
                    \*%......%*?????
                    \*%......%*?????
                    \*#......#******
                    \*#......######*
                    \*#...........#*
                    \*%...........%*
                    \*%...........%*
                    \*#...........#*
                    \*##%%%%%%%%%##*
                    \***************
                ]
            ]

            for i from 0 til 10
                @tryAddCustomRoom(grid,
                    Util.getRandomInt(0, grid.width),
                    Util.getRandomInt(0, grid.height),
                    @rotateRoomStringArrayRandom(Util.getRandomElement(custom_rooms))
                )

            for i from 0 til 100
                @tryAddRectangularRoom(grid,
                    Util.getRandomInt(0, grid.width),
                    Util.getRandomInt(0, grid.height),
                    Util.getRandomInt(6, 12),
                    Util.getRandomInt(6, 12),
                    2
                )

            for i from 0 til 100
                @tryAddRectangularRoom(grid,
                    Util.getRandomInt(0, grid.width),
                    Util.getRandomInt(0, grid.height),
                    Util.getRandomInt(6, 8),
                    Util.getRandomInt(6, 8),
                    1
                )

            @preConnect()

            ep_cands = @getEndpointCandidates(grid)

            @findNearestEndpointPair(ep_cands, grid)

            @translateTypes(grid)

            @grid = grid

            @resolveConnections()

            return grid
