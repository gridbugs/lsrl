define [
    'drawing/ascii_tiles'
    'types'
    'util'
], (AsciiTiles, Types, Util) ->
    
    const ColourType =
        White: '#ffffff'
        Black: '#000000'
        LightGreen: '#00ff00'
        DarkGreen: '#669900'
        DarkBrown: '#996600'
        LightGrey: '#888888'
        DarkGrey: '#666666'
        VeryDarkGrey: '#333333'
        LightRed: '#ff0000'
        Yellow:  '#ffff00'
        DarkYellow: '#888800'
        Purple: '#993399'

    class CanvasTile
        (@character, colour, @bold) -> 
            @colour = ColourType[colour]

    const TileStyles = AsciiTiles.createTileTable(CanvasTile)
    const SpecialColours = AsciiTiles.createSpecialColourTable(ColourType)
    
    const UnseenColour = '#333333'
    const SelectColour = '#888800'

    {
        TileStyles
        SpecialColours
    }