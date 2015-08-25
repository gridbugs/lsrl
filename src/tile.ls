define [
    \types
    \util
], (Types, Util) ->
    const TileNames =
        \ERROR
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

    const fixtureTilesTable = Util.join Types.Fixture, Types.Tile, {
        \Wall
        Web: \SpiderWeb
        \Tree
    }

    const groundTilesTable = Util.join Types.Ground, Types.Tile, {
        \Dirt
        \Stone
        \Moss
    }

    const itemTileTable = Util.join Types.Item, Types.Tile, {
        Stone: \ItemStone
        Plant: \ItemPlant
    }

    fromCell = (cell) ->

        if cell.items.length() > 0
            tile = itemTileTable[cell.items.first().type]
            return tile if tile?


        tile = fixtureTilesTable[cell.fixture.type]
        return tile if tile?

        tile = groundTilesTable[cell.ground.type]
        return tile if tile?

        return Types.Tile.Error


    {
        TileNames
        Tiles
        fromCell
    }
