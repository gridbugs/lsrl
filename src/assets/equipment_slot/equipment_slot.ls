define [
    'asset_system'
], (AssetSystem) ->

    AssetSystem.makeAssets 'EquipmentSlot', {
        Weapon: {}
        PreparedWeapon: {}
    }
