define [
    \types
], (Types) ->

    class Item
        ->
            @list = void

        isGroupable: -> false

    class GroupableItem extends Item
        -> super ...
        isGroupable: -> true

    class Stone extends GroupableItem
        ->
            super()    
            @type = Types.Item.Stone

        getName: -> "stone"

    class Plant extends GroupableItem
        ->
            super()
            @type = Types.Item.Plant
        getName: -> "plant"

    {
        Stone
        Plant
    }
