define [
    'drawing/unicode_tiles'
    'front_ends/console/colours'
], (UnicodeTiles, Colours) ->

    class Tile
        (@character, colour, @bold) ->
            @colour = Colours[colour]

    {
        TileSet: UnicodeTiles.createTileSet(Tile)
        TileType: UnicodeTiles.TileType
    }
