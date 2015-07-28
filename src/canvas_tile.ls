define ->
    const AsciiTileStyles =
        GRASS:  ['.', '#99ff33']
        STONE:  ['.', '#888888']
        DIRT:   ['.', '#996600']
        TREE:   ['&', '#669900']
        DEAD_TREE:  ['&', '#663300']
        WATER:  ['~', '#33CCFF']
        WALL:   ['#', '#444444']
        WOODEN_BRIDGE:  ['=', '#663300']
        STONE_BRIDGE:   ['=', '#888888']
        WOODEN_DOOR:    ['+', '#663300']
        STONE_DOOR:     ['+', '#888888']

    const AsciiPlayerCharacterStyle = ['@', 'white']

    {
        AsciiTileStyles
        AsciiPlayerCharacterStyle
    }
