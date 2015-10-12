define [
    'types'
    'util'
    'debug'
], (Types, Util, Debug) ->

    const FixtureTiles = Util.table Types.Fixture, Util.mergeObjects({
        Wall:       -> Types.Tile.Wall
        Web:        -> Types.Tile.SpiderWeb
        Tree:       -> Types.Tile.Tree
        Door:       (door) ->
                        if door.isOpen()
                            Types.Tile.OpenDoor
                        else
                            Types.Tile.Door
        DirtWall:   -> Types.Tile.DirtWall
        BrickWall:  -> Types.Tile.BrickWall
        Water:      -> Types.Tile.Water
        Bridge:     -> Types.Tile.Bridge
        /* TODO: learn how variable capture really works and make the next line less complicated */
    }, {[char, ((x) -> ( -> x)) (Types.Tile[char])] for char in Debug.chars})

    const GroundTiles = Util.table Types.Ground, {
        Dirt:       -> Types.Tile.Dirt
        Stone:      -> Types.Tile.Stone
        Moss:       -> Types.Tile.Moss
        Grass:      -> Types.Tile.Grass
    }

    const ItemTiles = Util.table Types.Item, {
        Stone:      -> Types.Tile.ItemStone
        Plant:      -> Types.Tile.ItemPlant
    }

    const CharacterTiles = Util.mapTable Types.Character, {
        Human:      -> Types.Tile.Human
        Shrubbery:  -> Types.Tile.Shrubbery
        PoisonShrubbery: -> Types.Tile.PoisonShrubbery
        CarnivorousShrubbery: -> Types.Tile.CarnivorousShrubbery
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
        fromCell
    }
