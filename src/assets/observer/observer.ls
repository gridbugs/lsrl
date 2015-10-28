define [
    'assets/observer/omniscient'
    'assets/observer/recursive_shadowcast'
    'asset_system'
], (Omniscient, RecursiveShadowcast, AssetSystem) ->

    AssetSystem.exposeAssets 'Observer', {
        Omniscient
        RecursiveShadowcast
    }
