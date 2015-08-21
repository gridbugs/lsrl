define [
    \types
    \util
], (Types, Util) ->

    const AsciiTileStyles = Util.table Types.Tile, {
        Error:  ['?', '#ff0000']
        Unknown:[' ', '#0000ff']
        Stone:  ['.', '#888888']
        Moss:   ['.', '#00ff00']
        Dirt:   ['.', '#996600']
        Tree:   ['&', '#669900']
        Wall:   ['#', '#666666']
        SpiderWeb:     ['*', '#888888']
    }

    const AsciiPlayerCharacterStyle = ['@', 'white']
    const UnseenColour = '#333333'
    const SelectColour = '#888800'
    {
        AsciiTileStyles
        AsciiPlayerCharacterStyle
        UnseenColour
        SelectColour
    }
