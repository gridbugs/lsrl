define ->
    const Colours =
        WHITE: 15
        BLACK: 16
        LIGHT_GREEN: 34
        DARK_GREEN: 22
        LIGHT_BROWN: 94
        DARK_BROWN: 58
        LIGHT_BLUE: 21
        LIGHT_GREY: 250
        DARK_GREY: 240
        LIGHT_RED: 196

    const TileStyles =
        UNKNOWN:['?', \LIGHT_RED]
        GRASS:  ['.', \LIGHT_GREEN]
        STONE:  ['.', \LIGHT_GREY]
        DIRT:   ['.', \DARK_BROWN]
        TREE:   ['&', \DARK_GREEN]
        DEAD_TREE:  ['&', \LIGHT_BROWN]
        WATER:  ['~', \LIGHT_BLUE]
        WALL:   ['#', \DARK_GREY]
        WOODEN_BRIDGE: ['=', \LIGHT_BROWN]
        STONE_BRIDGE: ['=', \LIGHT_GREY]
        WOODEN_DOOR: ['+', \LIGHT_BROWN]
        STONE_DOOR: ['+', \LIGHT_GREY]
        SPIDER_WEB: ['#', \LIGHT_GREY]

    const PlayerCharacterStyle = ['@', \WHITE]

    {
        Colours
        TileStyles
        PlayerCharacterStyle
    }
