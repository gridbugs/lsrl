define [
    'drawing/unicode_tiles'
    'types'
    'util'
], (Tiles, Types, Util) ->

    const ColourType =
        Red: '#ff0000'
        Green: '#00ff00'
        Blue: '#0000ff'
        White: '#ffffff'
        Black: '#000000'
        LightGreen: '#00ff00'
        DarkGreen: '#669900'
        DarkBrown: '#996600'
        LightBrown: '#996633'
        LightGrey: '#888888'
        DarkGrey: '#666666'
        VeryDarkGrey: '#333333'
        LightRed: '#ff0000'
        Yellow:  '#ffff00'
        DarkYellow: '#888800'
        Purple: '#993399'
        Orange: '#ff8800'
        Cyan: '#00ffff'
        Magenta: '#ff00ff'
        Pink: '#ff8888'

    class CanvasTile
        (@character, colour, @bold) ->
            @colour = ColourType[colour]

    const TileStyles = Tiles.createTileTable(CanvasTile)
    const SpecialColours = Tiles.createSpecialColourTable(ColourType)

    const UnseenColour = '#333333'
    const SelectColour = '#888800'

    {
        TileStyles
        SpecialColours
    }
