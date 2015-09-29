define [
    'drawing/character_tiles'
    'util'
    'types'
], (CharacterTiles, Util, Types) ->

    createTileTable = (Tiles, T) ->
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
