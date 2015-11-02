define [
    'system/character'
    'assets/weapon/weapon'
    'asset_system'
], (Character, Weapons, AssetSystem) ->

    class Spider extends Character
        (position, grid, Controller) ->
            super(position, grid, Controller)
            @weapon = new Weapons.BareHands()

    AssetSystem.exposeAsset('Character', Spider)
