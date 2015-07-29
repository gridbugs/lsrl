define [\util], (util) ->
    const TileNames =
        \GRASS
        \STONE
        \DIRT
        \TREE
        \DEAD_TREE
        \WATER
        \WALL
        \WOODEN_BRIDGE
        \STONE_BRIDGE
        \WOODEN_DOOR
        \STONE_DOOR
        \SPIDER_WEB

    Tiles = util.makeEnum TileNames

    {
        TileNames
        Tiles
    }
