define [
    'system/miscelaneous_item'
    'asset_system'
], (MiscelaneousItem, AssetSystem) ->

    class HealingPlant extends MiscelaneousItem
        ->
            super()

    class HealingFruit extends MiscelaneousItem
        ->
            super()

    AssetSystem.exposeAssets 'Item', {
        HealingPlant
        HealingFruit
    }
