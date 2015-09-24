define [
    'drawing/ascii_tiles'
    'front_ends/console/colours'
], (AsciiTiles, Colours) ->

    class Tile
        (@character, colour, @bold) ->
            @colour = Colours[colour]

    {
        TileTable: AsciiTiles.createTileTable(Tile)
        SpecialColours: AsciiTiles.createSpecialColourTable(Colours)
    }
