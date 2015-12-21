define [
    'system/effectable'
    'system/item'
], (Effectable, Item) ->

    class MiscelaneousItem implements Effectable, Item
        ->
            @initEffectable()

    return MiscelaneousItem
