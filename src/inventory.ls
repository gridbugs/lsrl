define [
    \alphabetic_item_collection
    \item_collection
], (AlphabeticItemCollection, ItemCollection) ->

    class Inventory extends AlphabeticItemCollection.AlphabeticItemCollection
        ->
            super(new ItemCollection.ItemCollection())

    {
        Inventory
    }
