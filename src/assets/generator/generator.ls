define [
    'assets/generator/castle'
    'assets/generator/surface'
    'asset_system'
], (Castle, Surface, AssetSystem) ->

    AssetSystem.exposeAssets 'Generator', {
        Castle
        Surface
    }
