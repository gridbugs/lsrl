define [\grid, \tile, \perlin, \vec2], (grid, tile, perlin, vec2) ->

    const PERLIN_SCALE = 0.1

    class PerlinTestGenerator
        ->
            @perlin = new perlin.PerlinGenerator!

        generate: (T, x, y) ->
            grid = new grid.Grid T, x, y
            grid.forEach (c) ~>
                c.type = parseInt(((@perlin.getNoise (vec2.Vec2 (c.x * PERLIN_SCALE), (c.y * PERLIN_SCALE))) + 1) * 5.5)

            grid.forEachBorder (c) ->
                c.type = tile.Tiles.TREE

            return grid

