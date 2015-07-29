define [
    \tile
    \effect
    'prelude-ls'
], (Tile, Effect, Prelude) ->

    map = Prelude.map

    class Cell
        (@x, @y) ->
            @type = void
            @effects = {}

        become: (c) ->
            @type = c.type
            @effects = {}
            for name, effect_list of c.effects
                @effects[name] = effect_list |> map (E) ~> new E this

    floorPrototype = (tile) -> {
        type: tile
        effects: {}
    }

    wallPrototype = -> {
        type: Tile.Tiles.WALL
        effects: {
            MoveToCell: [
                Effect.SolidCell
            ]
        }
    }
