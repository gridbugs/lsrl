define [
    'structures/grid'
    'generation/perlin'
    'structures/vec2'
    'cell/fixture'
    'debug'
    'util'
], (Grid, Perlin, Vec2, Fixture, Debug, Util) ->

    const PERLIN_SCALE = 0.1

    class PerlinTestGenerator

        generateGrid: (T, x, y) ->
            @perlin = new Perlin()
            @grid = new Grid(T, x, y)
            @grid.forEach (c) ~>
                i = parseInt(((@perlin.getNoise (new Vec2 (c.x * PERLIN_SCALE), (c.y * PERLIN_SCALE))) + 1) * 5.5)
                c.setFixture(Fixture[Debug.Chars[i]])

            return @grid

        getStartingPointHint: -> @grid.get(2, 2)
