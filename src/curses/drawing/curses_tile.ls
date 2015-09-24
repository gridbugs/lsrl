define [
    'drawing/ascii_tiles'
    'types'
    'util'
], (AsciiTiles, Types, Util) ->

    const ColourType =
        White: 15
        Black: 16
        LightGreen: 34
        DarkGreen: 22
        LightBrown: 94
        DarkBrown: 130
        LightBlue: 21
        LightGrey: 250
        DarkGrey: 240
        VeryDarkGrey: 236
        LightRed: 196
        Yellow:     11
        DarkYellow: 184
        Purple: 92

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
