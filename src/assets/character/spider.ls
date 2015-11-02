define [
    'system/character'
    'asset_system'
], (Character, AssetSystem) ->

    class Spider extends Character
        ->

    AssetSystem.exposeAsset('Character', Spider)
