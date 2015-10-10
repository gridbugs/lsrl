define [
    'generation/base_generator'
    'generation/perlin'
    'structures/grid'
    'structures/vec2'
    'structures/search'
    'cell/fixture'
    'cell/ground'
    'types'
    'debug'
    'util'
], (BaseGenerator, Perlin, Grid, Vec2, Search, Fixture, Ground, Types, Debug, Util) ->

    const PERLIN_SCALE = 0.1
    const FLOOD_MAX = 3
    const FLOOD_NOISE_COEF = 0.2
    const FLOOD_RANDOM_COEF = 0.1
    
    class Surface extends BaseGenerator

        getRiverStart: (start_candidates) ->
            @grid.forEachBorder (c) ->
                start_candidates.push(c)
            return Util.getRandomElement(start_candidates)

        getRiverEnd: (start, start_candidates) ->
            end_candidates = start_candidates.filter (c) ~>
                return Math.abs(c.position.x - start.position.x) > (@width * 0.5) and
                       Math.abs(c.position.y - start.position.y) > (@height * 0.5)
            if end_candidates.length == 0
                return void
            return Util.getRandomElement(end_candidates)

        generateGrid: (@T, @width, @height) ->
            @perlin = new Perlin()
            @grid = new Grid(@T, @width, @height)

            # assign each cell with its noise alue
            @grid.forEach (c) ~>
                i = @perlin.getNoise(new Vec2(c.x * PERLIN_SCALE, c.y * PERLIN_SCALE)) + 1
                c.setFixture(Fixture[Debug.chars[parseInt(i*4)]])
                c.setGround(Ground.Dirt)
                c.noiseValue = i
                c.floodTotal = 0


            # create a single river

            # start with a random border cell

            # find another border cell reasonably far away
            
            start = void
            end = void
            do 
                start_candidates = []
                start = @getRiverStart(start_candidates)
                end = @getRiverEnd(start, start_candidates)
            while not end?

            result = Search.findPath(start
                , (cell) -> cell.noiseValue + Math.random() * 0.5
                , (cell) -> true
                end
            )

            flood_queue = result.path.filter -> true
            for c in result.path
                c.setFixture(Fixture.A)

            while flood_queue.length != 0
                current = flood_queue.shift()
                current.setFixture(Fixture.Water)

                for n in current.allNeighbours
                    if n.floodTotal == 0
                        flood_total  = current.floodTotal + n.noiseValue * FLOOD_NOISE_COEF + 1 + Math.random() * FLOOD_RANDOM_COEF
                        if flood_total < FLOOD_MAX
                            n.floodTotal = flood_total
                            flood_queue.push(n)

            
            #start.setFixture(Fixture.B)
            #end.setFixture(Fixture.C)
         
            @grid.forEach (c) ->
                if c.fixture.type != Types.Fixture.Water
                    c.setFixture(Fixture.Null)
                    c.setGround(Ground.Grass)

            return @grid

        getStartingPointHint: -> @grid.get(2, 2)
