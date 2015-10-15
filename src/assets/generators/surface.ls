define [
    'generation/base_generator'
    'generation/perlin'
    'structures/grid'
    'structures/vec2'
    'structures/search'
    'structures/direction'
    'structures/doubly_linked_list'
    'structures/visited_list'
    'cell/fixture'
    'cell/ground'
    'constants'
    'types'
    'debug'
    'util'
], (BaseGenerator, Perlin, Grid, Vec2, Search, Direction, DoublyLinkedList, VisitedList,
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

    const BRIDGE_BRIDGE_PADDING = 16
    const BRIDGE_EDGE_PADDING = 3

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

        distanceToEdge: ->
            return Math.min(@grid.getDistanceToEdge(@waterStart),
                                    @grid.getDistanceToEdge(@waterEnd))

        distanceToBridge: (bridge) ->
            return (@preWaterStart.position.distance(bridge.preWaterStart.position) +
                   @postWaterEnd.position.distance(bridge.postWaterEnd.position)) / 2
        place: ->
            cell = @waterStart
            for i from 0 til @length
                cell.setFixture(Fixture.Bridge)
                cell = @grid.getCart(cell.position.add(@directionVector))
            @preWaterStart.bridges.push(this)
            @preWaterStart.bridgeDirections.push(@direction)
            @postWaterEnd.bridges.push(this)
            @preWaterStart.bridgeDirections.push(Direction.Opposites[@direction])

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

        createBridge: (start, end, direction, length) ->
            return new BridgeCandidate(@grid, start, end, direction, length)

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
            visited = []
            for c in path
                c.width = 0
                c.origin = c
                visited.push(c)
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
                            visited.push(n)

            for v in visited
                v.width = void
                v.origin = void

        generateDecayingTreesAtBorder: (depth) ->

            for i from 0 til depth
                @grid.forEachBorderAtDepth i, (c) ->
                    if c.fixture.type != Types.Fixture.Water
                        if Math.random() < i
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

        generateTreeSteps: (n) ->
            for i from 0 til n
                @generateTreeStep()

        generateTrees: ->
            @computeDistancesToWater()
            @generateDecayingTreesAtBorder(4)
            @generateTreeSteps(20)

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
                        candidates.push(@createBridge(start, @grid.get(j - 1, i), Types.Direction.East, j - start.position.x))

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
                       candidates.push(@createBridge(start, @grid.get(j, i - 1), Types.Direction.South, i - start.position.y))

            return candidates.filter (c) -> c.isValid()

        tryGenerateBridge: (candidate_list, bridges, bridge_padding, edge_padding, max_length) ->
            iterator = candidate_list.getForwardIterator()
            while iterator.hasNext()
                current = iterator.get()

                close_to_bridge = false
                for b in bridges
                    if current.distanceToBridge(b) <= bridge_padding
                        close_to_bridge = true
                        break

                if not close_to_bridge and current.distanceToEdge() > edge_padding and
                    current.length < max_length

                    iterator.removeCurrent()
                    return current

                iterator.next()
            return void

        tryGenerateBridges: (bridge_padding, edge_padding, attempts, max_bridges, max_length) ->
            candidates = @getBridgeCandidates()
            Util.shuffleArrayInPlace(candidates)

            list = DoublyLinkedList.fromArray(candidates)
            bridges = []
            bridge_count = 0

            for i from 0 til attempts
                bridge = @tryGenerateBridge(list, bridges, bridge_padding, edge_padding, max_length)
                if bridge?
                    ++bridge_count
                    bridges.push(bridge)

                    if bridge_count >= max_bridges
                        break

            if bridges.length == 0
                return void

            return bridges

        generateBridges: (bridge_padding = BRIDGE_BRIDGE_PADDING, edge_padding = BRIDGE_EDGE_PADDING,
                            attempts = 20, max_bridges = 3, min_bridges = 2, max_length = 12) ->

                bridges = @tryGenerateBridges(bridge_padding, edge_padding, attempts, max_bridges, max_length)
                if bridges? and bridges.length >= min_bridges
                    @bridges = bridges
                    @grid.forEach (c) ->
                        c.bridges = []
                        c.bridgeDirections = []
                    for b in @bridges
                        b.place()
                    return true
                else
                    return false

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

            return @pathFromResults(results)

        pathFromResults: (results) ->

            if not results?
                return void

            for c in results.fullPath
                c.setFixture(Fixture.Null)
                c.setGround(Ground.Dirt)

                for n in c.allNeighbours
                    if n.fixture.type == Types.Fixture.Tree and not @grid.isBorderCell(n)
                        n.setFixture(Fixture.Null)

            for c in results.fullPath
                c.path = true

            return results.fullPath



        computeDistancesToWater: ->
            queue = new DoublyLinkedList()

            @grid.forEach (c) ->
                if c.fixture.type == Types.Fixture.Water
                    c.distanceToWater = 0
                    queue.enqueue(c)

            until queue.empty()
                current = queue.dequeue()
                for n in current.allNeighbours
                    if not n.distanceToWater?
                        n.distanceToWater = current.distanceToWater + 1
                        queue.enqueue(n)

        computeDistancesToBridge: ->
            queue = new DoublyLinkedList()

            @grid.forEach (c) ->
                if c.fixture.type == Types.Fixture.Bridge
                    c.distanceToBridge = 0
                    queue.enqueue(c)

            until queue.empty()
                current = queue.dequeue()
                for n in current.allNeighbours
                    if not n.distanceToBridge?
                        n.distanceToBridge = current.distanceToBridge + 1
                        queue.enqueue(n)

        createPointOfInterest: (space) ->
            candidates = space.filter (c) ~>
                return @grid.getDistanceToEdge(c) > 2

            return Util.arrayMost candidates, (c) ~>
                return c.distanceToBridge

        connectToPathOrPoint: (start, end) ->
            results = Search.findClosest(start
                , (cell) ->
                    multiplier = 1
                    if cell.fixture.type == Types.Fixture.Tree
                        multiplier = 2
                    return multiplier * cell.absoluteNoiseValue
                , (cell) ~>
                    return cell.fixture.type != Types.Fixture.Water and \
                           cell.fixture.type != Types.Fixture.Bridge and \
                           not @grid.isBorderCell(cell)
                , (cell) ->
                    return cell.path? or cell.position.equals(end.position)
                , true
                , Direction.CardinalDirections
            )

            return @pathFromResults(results)

        addPathsToSpace: (space_id) ->
            poi = @createPointOfInterest(@spaces[space_id])
            path_start_candidates = []
            for c in @spaces[space_id]
                if c.bridges.length > 0
                    path_start_candidates.push(c)

            Util.shuffleArrayInPlace(path_start_candidates)

            path_start = path_start_candidates.pop()

            @connectWithPath(path_start, poi)
            for c in path_start_candidates
                @connectToPathOrPoint(c, poi)

            return poi

        generateGrid: (@T, @width, @height) ->
            @grid = new Grid(@T, @width, @height)

            done = false

            until done
                @grid.forEach (c) ->
                    c.setFixture(Fixture.Null)
                    c.setGround(Ground.Grass)
                    c.space = void
                    c.path = void

                @addPerlinNoise()
                @enumerateBorder(0.3)
                @generateMainRiver()

                @classifySpaces()

                @generateTrees()

                done = @generateBridges()

            @computeDistancesToWater()
            @computeDistancesToBridge()

            @addPathsToSpace(@largestSpace)
            @startPoint = @addPathsToSpace(@secondLargestSpace)

            @generateTreeSteps(2)
            return @grid

        getStartingPointHint: ->
            return @startPoint