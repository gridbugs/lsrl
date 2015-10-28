define [
    'system/item'
    'asset_system'
], (Item, AssetSystem) ->

    class Stone extends Item.GroupableItem
        ->
            super()
        getName: -> "Stone"

    class Plant extends Item.GroupableItem
        ->
            super()
        getName: -> "Plant"

    AssetSystem.exposeAssets 'Item', {
        Stone
        Plant
    }
