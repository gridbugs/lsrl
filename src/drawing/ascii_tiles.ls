define [
    'util'
    'types'
], (Util, Types) ->

    class AsciiTile
        (@character, @colour, @bold) ->

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

    createTileTable = (T) ->
        return Util.mapTable(Types.Tile, Tiles, (arr) -> new T(arr[0], arr[1], arr[2]))

    createSpecialColourTable = (colour_table) ->
        return {
            Unseen:     colour_table['VeryDarkGrey']
            Selected:   colour_table['DarkYellow']
        }       

    {
        createTileTable
        createSpecialColourTable
    }
