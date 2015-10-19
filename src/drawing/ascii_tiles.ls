define [
    'drawing/tile'
    'tile_schemes/default'
    'util'
    'types'
    'debug'
], (Tile, DefaultTileScheme, Util, Types, Debug) ->

    Tiles =
        Error:                      ['?', 'LightRed',   false]
        Unknown:                    [' ', 'Black',      false]
        Stone:                      ['.', 'LightGrey',  false]
        Dirt:                       ['.', 'DarkBrown',  false]
        Tree:                       ['&', 'DarkGreen',  false]
        Wall:                       ['#', 'DarkGrey',   false]
        SpiderWeb:                  ['*', 'LightGrey',  false]
        Moss:                       ['.', 'LightGreen', false]
        ItemStone:                  ['[', 'LightGrey',  false]
        ItemPlant:                  ['%', 'LightGreen', false]
        Door:                       ['+', 'LightGrey',  false]
        OpenDoor:                   ['-', 'LightGrey',  false]
        Human:                      ['h', 'White',      true]
        Shrubbery:                  ['p', 'DarkGreen',  true]
        PoisonShrubbery:            ['p', 'Purple',     true]
        CarnivorousShrubbery:       ['p', 'LightGreen', true]
        PlayerCharacter:            ['@', 'White',      true]
        DirtWall:                   ['#', 'DarkBrown',  false]
        BrickWall:                  ['#', 'LightRed',   false]

    Debug.Chars.map (ch) ->
        Tiles[ch] = [ch, 'White', false]

    {
        createTileTable: (T) -> CharacterTiles.createTileTable(Tiles, DefaultTileScheme.TileType, T)
    }
