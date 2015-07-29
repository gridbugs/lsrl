define [
    \tile
], (Tile) ->
    
    class Cell
        (@x, @y) ->
            @type = void
            @effects = {}

        become: (c) ->
            @type = c.type
            @effects = c.effects

    floorPrototype = (tile) ->
        type: tile
        effects: {}
    }

    wallPrototype = -> {
        type: Tile.Tiles.WALL
        effects: {
                   
        }
    }
