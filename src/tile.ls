define [
    \util
], (Util) ->
    const TileNames =
        \UNKNOWN
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

    Tiles = Util.enum TileNames

    const fixtureTiles =
        Wall:   Tiles.WALL
        Web:    Tiles.SPIDER_WEB

    const groundTiles =
        Dirt: Tiles.DIRT

    fromCell = (cell) ->

        name = cell.fixture.constructor.name
        return fixtureTiles[name] if fixtureTiles[name]?
        
        name = cell.ground.constructor.name
        return groundTiles[name] if groundTiles[name]?

        return Tiles.UNKNOWN


    {
        TileNames
        Tiles
        fromCell
    }
