define [
    'structures/grid'
    'drawing/tile'
    'generation/perlin'
    'structures/vec2'
], (Grid, Tile, Perlin, Vec2) ->

    const PERLIN_SCALE = 0.1

    class PerlinTestGenerator
        ->
            @perlin = new Perlin.PerlinGenerator!

        generate: (T, x, y) ->
            grid = new Grid.Grid T, x, y
            grid.forEach (c) ~>
                c.type = parseInt(((@perlin.getNoise (Vec2.Vec2 (c.x * PERLIN_SCALE), (c.y * PERLIN_SCALE))) + 1) * 5.5)

            grid.forEachBorder (c) ->
                c.type = Tile.Tiles.TREE

            return grid

