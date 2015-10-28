define [
    'action/effectable'
    'util'
], (Effectable, Util) ->

    GlobalItemId = 100
    getItemId = -> (GlobalItemId++)

    class Item implements Effectable
        ->
            @initEffectable()
            @collection = void
            @id = getItemId()
            @groupable = false

        isGroupable: -> @groupable
        getGroupId: -> @id
        makeUnique: -> @groupable = false

    class GroupableItem extends Item
        ->
            super()
            @groupable = true

        getGroupId: -> @type

    Item.GroupableItem = GroupableItem

    return Item
