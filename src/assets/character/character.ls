define [
    'assets/character/shrubberies'
    'assets/character/human'
    'asset_system'
    'util'
], (Shrubberies, Human, AssetSystem, Util) ->

    AssetSystem.exposeAssets 'Character', Util.mergeObjects Shrubberies, {
        Human
    }
