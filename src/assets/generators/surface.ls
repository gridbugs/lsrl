define [
    'generation/base_generator'
    'generation/perlin'
    'structures/grid'
    'structures/vec2'
    'structures/search'
    'structures/direction'
    'structures/doubly_linked_list'
    'cell/fixture'
    'cell/ground'
    'constants'
    'types'
    'debug'
    'util'
], (BaseGenerator, Perlin, Grid, Vec2, Search, Direction, DoublyLinkedList,
    Fixture, Ground, Constants, Types, Debug, Util) ->

    const PERLIN_SCALE = 0.05
    const PERLIN_SEARCH_MULTIPLIER = 1
    const PERLIN_SEARCH_OFFSET = 0

    const RIVER_HARD_PADDING = 3
    const RIVER_SOFT_PADDING = 5
    const MAIN_RIVER_WIDTH_LIMIT = 4
    const MAIN_RIVER_WIDTH_MULTIPLIER = 20
    const MAIN_RIVER_WIDTH_OFFSET = 0.5

    const TREE_GROW_DISTANCE_MULTIPLIER =       0.05
    const TREE_SURVIVE_DISTANCE_MULTIPLIER =    0.05

    const TreeGrowProbabilities = [
        0,      # 0
        0.2,    # 1
        0.6,    # 2
        0.9,    # 3
        0.7,    # 4
        0.6,    # 5
        0.5,    # 6
        0.2,    # 7
        0.1,    # 8
    ]

    const TreeSurviveProbabilities = [
        0.2,    # 0
        0.6,    # 1
        1.0,    # 2
        1.0,    # 3
        0.9,    # 4
        0.9,    # 5
        0.8,    # 6
        0.8,    # 7
        0.7,    # 8
    ]

    class BridgeCandidate
        (@grid, @waterStart, @waterEnd, @direction, @length) ->
            @directionVector = Direction.Vectors[@direction]
            @preWaterStart = @grid.getCart(@waterStart.position.subtract(@directionVector))
            @postWaterEnd = @grid.getCart(@waterEnd.position.add(@directionVector))

        isValid: ->
            return @preWaterStart? and @postWaterEnd? and @preWaterStart.space != @postWaterEnd.space and
                   @waterStart.position.x != 0 and @waterStart.position.y != 0 and
                   @waterEnd.position.x != 0 and @waterEnd.position.y != 0 and
                   @preWaterStart.isInLargeSpace and @postWaterEnd.isInLargeSpace and
                   not @grid.isBorderCell(@preWaterStart) and not @grid.isBorderCell(@postWaterEnd)

        distanceToBridge: (bridge) ->
            return (@preWaterStart.position.distance(bridge.preWaterStart.position) +
                   @postWaterEnd.position.distance(bridge.postWaterEnd.position)) / 2
        place: ->
            cell = @waterStart
            for i from 0 til @length
                cell.setFixture(Fixture.Bridge)
                cell = @grid.getCart(cell.position.add(@directionVector))

    class Surface extends BaseGenerator

        enumerateBorder: (absolute_noise_limit = 1)->
            @border = []
            @grid.forEachBorder (c) ~>
                if c.absoluteNoiseValue < absolute_noise_limit
                    @border.push(c)

        getRandomBorderCell: ->
            return Util.getRandomElement(@border)

        getRandomBorderCellAtXYDistance: (cell, x_distance, y_distance) ->
            candidates = @border.filter (c) ->
                return Math.abs(c.position.x - cell.position.x) > x_distance and
                       Math.abs(c.position.y - cell.position.y) > y_distance
            if candidates.length == 0
                return void
            return Util.getRandomElement(candidates)

        addPerlinNoise: ->

            @perlin = new Perlin()

            # assign each cell with its noise alue
            @grid.forEach (c) ~>
                i = @perlin.getNoise(new Vec2(c.x * PERLIN_SCALE, c.y * PERLIN_SCALE))
                c.setFixture(Fixture[Debug.chars[parseInt((i+1)*4)]])
                c.noiseValue = i
                c.positiveNoiseValue = i + 1
                c.absoluteNoiseValue = Math.abs(i)

        findClosest: (start, predicate, can_enter_predicate = (-> true), can_enter_dest = true, directions = Direction.Directions) ->
            return Search.findClosest(start
                , (cell, direction) ->
                    multiplier = 1
                    if Direction.isOrdinal(direction)
                        multiplier = Constants.SQRT2
                    return multiplier * (PERLIN_SEARCH_OFFSET + PERLIN_SEARCH_MULTIPLIER * cell.absoluteNoiseValue)
                , can_enter_predicate
                , predicate
                , can_enter_dest
                , directions
            )

        findPath: (start, end, can_enter_predicate = (-> true), can_enter_dest = true, directions = Direction.Directions) ->
            return @findClosest(start
                , (cell) -> cell.position.equals(end.position)
                , can_enter_predicate
                , can_enter_dest
                , directions
            )

        ################### general methods above this line ########################


        getMainRiverStart: ->
            return @getRandomBorderCell()

        getMainRiverEnd: (start) ->
            return Util.retryWhileUndefined((~> @getRandomBorderCellAtXYDistance(start, @width/4, @height/4)), -1)

        getMainRiverInsidePadding: (start) ->
            results = @findClosest(start
                , (cell) ~> @grid.getDistanceToEdge(cell) > RIVER_SOFT_PADDING
            )

            return results

        getMainRiverPath: ->
            start = @getMainRiverStart()
            end = @getMainRiverEnd(start)

            start_inside_results = @getMainRiverInsidePadding(start)
            end_inside_results = @getMainRiverInsidePadding(end)

            results = @findPath(start_inside_results.cell, end_inside_results.cell
                , (cell) ~> @grid.getDistanceToEdge(cell) > RIVER_SOFT_PADDING
                , false
            )

            return start_inside_results.fullPath.concat(results.fullPath).concat(end_inside_results.fullPath)


        generateMainRiver: ->
            path = @getMainRiverPath()
            for c in path
                c.width = 0
                c.origin = c
            queue = DoublyLinkedList.fromArray(path)

            until queue.empty()
                current = queue.dequeue()
                current.setFixture(Fixture.Water)
                if @grid.getDistanceToEdge(current.origin) > RIVER_HARD_PADDING and @grid.getDistanceToEdge(current) <= RIVER_HARD_PADDING
                    continue

                if current.width < MAIN_RIVER_WIDTH_LIMIT
                    for n in current.allNeighbours
                        if not n.width?
                            n.width = current.width + MAIN_RIVER_WIDTH_OFFSET + n.absoluteNoiseValue * MAIN_RIVER_WIDTH_MULTIPLIER
                            n.origin = current.origin
                            queue.enqueue(n)

        generateInitialTrees: ->
            @grid.forEachBorderAtDepth 0, (c) ->
                if c.fixture.type != Types.Fixture.Water
                    c.setFixture(Fixture.Tree)

            @grid.forEachBorderAtDepth 1, (c) ->
                if c.fixture.type != Types.Fixture.Water
                    if Math.random() < 0.5
                        c.setFixture(Fixture.Tree)

            @grid.forEachBorderAtDepth 2, (c) ->
                if c.fixture.type != Types.Fixture.Water
                    if Math.random() < 0.25
                        c.setFixture(Fixture.Tree)

            @grid.forEachBorderAtDepth 3, (c) ->
                if c.fixture.type != Types.Fixture.Water
                    if Math.random() < 0.125
                        c.setFixture(Fixture.Tree)

        generateTreeStep: ->
            @grid.forEach (cell) ~>
                if cell.fixture.type == Types.Fixture.Water
                    cell.nextFixture = Fixture.Water
                else if cell.fixture.type == Types.Fixture.Bridge
                    cell.nextFixture = Fixture.Bridge
                else if @grid.isBorderCell(cell)
                    cell.nextFixture = Fixture.Tree
                else if cell.fixture.type == Types.Fixture.Null and cell.ground.type == Types.Ground.Dirt
                    cell.nextFixture = Fixture.Null
                else
                    num_adjacent_trees = cell.countNeighboursSatisfying (c) -> c.fixture.type == Types.Fixture.Tree
                    num_adjacent_water = cell.countNeighboursSatisfying (c) -> c.fixture.type == Types.Fixture.Water

                    distance = Math.min(cell.distanceToWater, @grid.getDistanceToEdge(cell))

                    if cell.fixture.type == Types.Fixture.Null
                        probability = TreeGrowProbabilities[num_adjacent_trees] - TREE_GROW_DISTANCE_MULTIPLIER * distance
                    else
                        probability = TreeSurviveProbabilities[num_adjacent_trees] - TREE_SURVIVE_DISTANCE_MULTIPLIER * distance

                    if Math.random() < probability
                        cell.nextFixture = Fixture.Tree
                    else
                        cell.nextFixture = Fixture.Null


            @grid.forEach (cell) ~>
                cell.setFixture(cell.nextFixture)

        generateTrees: ->
            @computeDistancesToWater()
            @generateInitialTrees()
            for i from 0 til 20
                @generateTreeStep()

        computeDistancesToWater: ->
            array = []
            @grid.forEach (cell) ->
                if cell.fixture.type == Types.Fixture.Water
                    cell.distanceToWater = 0
                    array.push(cell)

            queue = DoublyLinkedList.fromArray(array)

            until queue.empty()
                current = queue.dequeue()

                for d in Direction.Directions
                    n = current.neighbours[d]
                    if n? and not n.distanceToWater?
                        n.distanceToWater = current.distanceToWater + Direction.getMultiplier(d)
                        queue.enqueue(n)

        classifySpaces: ->
            @numSpaces = 0
            @spaceSizes = []
            @spaces = []
            @grid.forEach (c) ~>
                if c.fixture.type != Types.Fixture.Water and not c.space?
                    @spaces[@numSpaces] = []
                    @spaceSizes[@numSpaces] = 0
                    queue = DoublyLinkedList.fromSingleElement(c)
                    c.space = @numSpaces
                    until queue.empty()
                        current = queue.dequeue()
                        @spaces[@numSpaces].push(current)
                        ++@spaceSizes[@numSpaces]

                        for n in current.allNeighbours
                            if n.fixture.type != Types.Fixture.Water and not n.space?
                                queue.enqueue(n)
                                n.space = @numSpaces

                    ++@numSpaces

            @spaceIdsDescendingOrder = [0 til @numSpaces]
            @spaceIdsDescendingOrder.sort (a, b) ~> @spaceSizes[b] - @spaceSizes[a]

            @largestSpace = @spaceIdsDescendingOrder[0]
            @secondLargestSpace = @spaceIdsDescendingOrder[1]

            for c in @spaces[@largestSpace]
                c.isInLargeSpace = true
            for c in @spaces[@secondLargestSpace]
                c.isInLargeSpace = true

        attemptAddBridge: (candidates, bridge) ->
            if bridge.isValid()
                candidates.push(bridge)

        getBridgeCandidates: ->
            candidates = []

            # traverse each row
            for i from 0 til @grid.height
                j = 0
                while j < @grid.width
                    start = void
                    while j < @grid.width and @grid.get(j, i).fixture.type != Types.Fixture.Water
                        ++j
                    if j >= @grid.width
                        break
                    start = @grid.get(j, i)
                    while j < @grid.width and @grid.get(j, i).fixture.type == Types.Fixture.Water
                        ++j

                    if j < @grid.width
                        @attemptAddBridge(candidates, new BridgeCandidate(@grid, start, @grid.get(j - 1, i), Types.Direction.East, j - start.position.x))

            # traverse each column
            for j from 0 til @grid.width
                i = 0
                while i < @grid.height
                    start = void
                    while i < @grid.height and @grid.get(j, i).fixture.type != Types.Fixture.Water
                        ++i
                    if i >= @grid.height
                        break
                    start = @grid.get(j, i)
                    while i < @grid.height and @grid.get(j, i).fixture.type == Types.Fixture.Water
                        ++i
                    if i < @grid.height
                        @attemptAddBridge(candidates, new BridgeCandidate(@grid, start, @grid.get(j, i - 1), Types.Direction.South, i - start.position.y))

            return candidates

        generateBridges: ->
            candidates = @getBridgeCandidates()
            Util.shuffleArrayInPlace(candidates)

            short_candidates = candidates.filter (bridge) -> bridge.length < 8

            if short_candidates.length > 0
                main_bridge = short_candidates.pop()
            else
                main_bridge = candidates.pop()

            main_bridge.place()
            @bridges = [main_bridge]

            remaining_candidates = candidates.filter (bridge) ->
                bridge.distanceToBridge(main_bridge) > 20
            remaining_candidates.sort (a, b) -> a.length - b.length
            remaining_candidates = remaining_candidates.filter (bridge) -> bridge.length < 10

            if remaining_candidates.length > 0
                bridge = remaining_candidates.pop()
                bridge.place()
                @bridges.push(bridge)

            if @bridges.length != 2
                @startCandidates = []
                @grid.forEach (c) ~>
                    if c.fixture.type == Types.Fixture.Null
                        @startCandidates.push(c)
                return


            @bridgesStarting = []
            @bridgesEnding = []

            for i from 0 til @numSpaces
                @bridgesStarting[i] = []
                @bridgesEnding[i] = []

            for b in @bridges
                @bridgesStarting[b.preWaterStart.space].push(b)
                @bridgesEnding[b.postWaterEnd.space].push(b)

            path_ends = []
            for b in @bridgesStarting[@largestSpace]
                path_ends.push(b.preWaterStart)
            for b in @bridgesEnding[@largestSpace]
                path_ends.push(b.postWaterEnd)

            @connectWithPath(path_ends[0], path_ends[1])

            path_ends = []
            for b in @bridgesStarting[@secondLargestSpace]
                path_ends.push(b.preWaterStart)
            for b in @bridgesEnding[@secondLargestSpace]
                path_ends.push(b.postWaterEnd)

            path_ends[0].setFixture(Fixture.A)
            path_ends[1].setFixture(Fixture.B)
            @connectWithPath(path_ends[0], path_ends[1])

        connectWithPath: (a, b) ->
            results = Search.findPath(a
                , (cell) ->
                    multiplier = 1
                    if cell.fixture.type == Types.Fixture.Tree
                        multiplier = 2
                    return multiplier * cell.absoluteNoiseValue
                , (cell) ~>
                    return cell.fixture.type != Types.Fixture.Water and \
                           cell.fixture.type != Types.Fixture.Bridge and \
                           not @grid.isBorderCell(cell)
                , b
                , Direction.CardinalDirections
            )

            if not results?
                return void

            @startCandidates = []
            for c in results.fullPath
                c.setFixture(Fixture.Null)
                c.setGround(Ground.Dirt)
                @startCandidates.push(c)

        removePathAdjacentTrees: ->
            @grid.forEach (c) ~>
                if c.fixture.type == Types.Fixture.Null and \
                    c.ground.type == Types.Ground.Dirt

                    for n in c.allNeighbours
                        if n.fixture.type == Types.Fixture.Tree and not @grid.isBorderCell(n)
                            n.setFixture(Fixture.Null)

        generateGrid: (@T, @width, @height) ->
            @grid = new Grid(@T, @width, @height)

            @grid.forEach (c) ->
                c.setFixture(Fixture.Null)
                c.setGround(Ground.Grass)

            @addPerlinNoise()
            @enumerateBorder(0.3)
            @generateMainRiver()

            @classifySpaces()

            @generateTrees()

            @generateBridges()
            @removePathAdjacentTrees()

            for i from 0 til 2
                @generateTreeStep()

            return @grid

        getStartingPointHint: ->
            return Util.getRandomElement(@startCandidates)
