define [
    'generation/base_generator'
    'generation/perlin'
    'structures/grid'
    'structures/vec2'
    'cell/fixture'
    'debug'
    'util'
], (BaseGenerator, Perlin, Grid, Vec2, Fixture, Debug, Util) ->

    const PERLIN_SCALE = 0.1
    
    class Surface extends BaseGenerator
        generateGrid: (@T, @width, @height) ->
            @perlin = new Perlin()
            @grid = new Grid(@T, @width, @height)
            @grid.forEach (c) ~>
                i = parseInt(((@perlin.getNoise (new Vec2 (c.x * PERLIN_SCALE), (c.y * PERLIN_SCALE))) + 1) * 5.5)
                c.setFixture(Fixture[Debug.chars[i]])

            return @grid
