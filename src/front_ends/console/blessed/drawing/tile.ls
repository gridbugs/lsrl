define [
    'drawing/unicode_tiles'
    'front_ends/console/colours'
], (Tiles, Colours) ->

    class Tile
        (@character, colour, @bold) ->
            @colour = Colours[colour]

    {
        TileTable: Tiles.createTileTable(Tile)
        SpecialColours: Tiles.createSpecialColourTable(Colours)
    }
