require! './Grid.ls': {Grid}
require! './Tiles.ls': {Tiles}
require! './Perlin.ls': {PerlinGenerator}
require! './Vec2.ls': {vec2}

const PERLIN_SCALE = 0.1

export class PerlinTestGenerator
    ->
        @perlin = new PerlinGenerator!

    generate: (T, x, y) ->
        grid = new Grid T, x, y
        grid.forEach (c) ~>
            c.type = parseInt(((@perlin.getNoise (vec2 (c.x * PERLIN_SCALE), (c.y * PERLIN_SCALE))) + 1) * 5.5)

        grid.forEachBorder (c) ->
            c.type = Tiles.TREE

        return grid

