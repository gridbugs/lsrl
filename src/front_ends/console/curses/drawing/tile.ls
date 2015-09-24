define [
    'drawing/ascii_tiles'
    'front_ends/console/colours'
], (AsciiTiles, ColourType) ->

    class CursesTile
        (@character, colour, @bold) -> 
            @colour = ColourType[colour]
            @pair = void

    const TileStyles = AsciiTiles.createTileTable(CursesTile)
    const SpecialColours = AsciiTiles.createSpecialColourTable(ColourType)

    {
        TileStyles
        ColourType
        SpecialColours
    }
