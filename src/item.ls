define [
    \types
    \util
], (Types, Util) ->

    GlobalItemId = Object.keys(Types.Item).length
    getItemId = -> (GlobalItemId++)

    class Item
        ->
            @collection = void
            @id = getItemId()
            @groupable = false

        isGroupable: -> @groupable
        getGroupId: -> @id
        makeUnique: -> @groupable = false

    class GroupableItem extends Item
        ->
            super ...
            @groupable = true

        getGroupId: -> @type

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
