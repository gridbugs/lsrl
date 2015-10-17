define [
    'drawing/character_tiles'
    'util'
    'debug'
], (CharacterTiles, Util, Debug) ->

    const TileType = Util.enum([
        \Error
        \Unknown
        \Stone
        \Dirt
        \Tree
        \Wall
        \SpiderWeb
        \Moss
        \ItemStone
        \ItemPlant
        \Door
        \OpenDoor
        \Human
        \Shrubbery
        \PoisonShrubbery
        \CarnivorousShrubbery
        \PlayerCharacter
        \BrickWall
        \DirtWall
        \Water
        \Water2
        \Grass
        \Bridge
    ] ++ Debug.Chars)

    /* Given a description of character tiles with characters, colours and weights (ie. bold or not),
     * and a constructor for a tile object, returns a table mapping tile types to objects of the
     * given type representing the corresponding tiles.
     */
    createTileSet = (Tiles, T) ->
        return Util.mapTable(TileType, Tiles, (arr) -> new T(arr[0], arr[1], arr[2]))

    {
        createTileSet
        TileType
    }
