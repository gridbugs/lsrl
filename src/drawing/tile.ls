define [
    'types'
    'util'
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

    const FixtureTiles = Util.table Types.Fixture, {
        Wall:       -> Types.Tile.Wall
        Web:        -> Types.Tile.SpiderWeb
        Tree:       -> Types.Tile.Tree
        Door:       (door) ->
                        if door.isOpen()
                            Types.Tile.OpenDoor
                        else
                            Types.Tile.Door
    }

    const GroundTiles = Util.table Types.Ground, {
        Dirt:       -> Types.Tile.Dirt
        Stone:      -> Types.Tile.Stone
        Moss:       -> Types.Tile.Moss
    }

    const ItemTiles = Util.table Types.Item, {
        Stone:      -> Types.Tile.ItemStone
        Plant:      -> Types.Tile.ItemPlant
    }

    const CharacterTiles = Util.mapTable Types.Character, {
        Human:      -> Types.Tile.Human
        Shrubbery:  -> Types.Tile.Shrubbery
    }, (fn) ->
        return (character) ->
            if character.isPlayerCharacter()
                return Types.Tile.PlayerCharacter
            else
                return fn(character)

    fromCell = (cell) ->

        tile = CharacterTiles[cell.character?.type]?(cell.character)
        return tile if tile?

        if cell.items.length() > 0
            top_item = cell.items.first()
            tile = ItemTiles[top_item.type]?(top_item)
            return tile if tile?

        tile = FixtureTiles[cell.fixture.type]?(cell.fixture)
        return tile if tile?

        tile = GroundTiles[cell.ground.type]?(cell.ground)
        return tile if tile?

        return Types.Tile.Error


    {
        TileNames
        Tiles
        fromCell
    }
