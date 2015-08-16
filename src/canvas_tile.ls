define [
    \types
    \util
], (Types, Util) ->
    /*
    const AsciiTileStyles =
        ERROR:  ['?', '#ff0000']
        UNKNOWN:[' ', '#000000']
        GRASS:  ['.', '#99ff33']
        STONE:  ['.', '#888888']
        DIRT:   ['.', '#996600']
        TREE:   ['&', '#669900']
        DEAD_TREE:  ['&', '#663300']
        WATER:  ['~', '#33CCFF']
        WALL:   ['#', '#666666']
        WOODEN_BRIDGE:  ['=', '#663300']
        STONE_BRIDGE:   ['=', '#888888']
        WOODEN_DOOR:    ['+', '#663300']
        STONE_DOOR:     ['+', '#888888']
        SPIDER_WEB:     ['*', '#888888']
    */
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
