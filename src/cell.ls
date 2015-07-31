define [
    \tile
    \effect
    \util
    'prelude-ls'
], (Tile, Effect, Util, Prelude) ->

    map = Prelude.map

    class Cell
        (@x, @y) ->
            @type = void
            @effects = []

        toString: -> "#{@type}"

        become: (c) ->
            @type = c.type
            @effects = c.effects |> map (E) ~> new E this

    floorPrototype = (tile) -> {
        type: tile
        effects: []
    }

    wallPrototype = -> {
        type: Tile.Tiles.WALL
        effects: [
            Effect.CellIsSolid
        ]
    }

    {
        Cell
        floorPrototype
        wallPrototype
    }
