define [
    \tile
    \effect
    'prelude-ls'
], (Tile, Effect, Prelude) ->

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
            Effect.SolidCellEffect
        ]
    }

    {
        Cell
        floorPrototype
        wallPrototype
    }
