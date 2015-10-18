define [
    'util'
], (Util) ->

    createTileSet = (tile_obj, tile_type, T) ->
        return Util.mapTable(tile_type, tile_obj, (arr) -> new T(arr[0], arr[1], arr[2]))

    {
        createTileSet
    }
