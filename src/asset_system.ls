define [
    'type_system'
    'assets/assets'
], (TypeSystem, Assets) ->
    {
        makeAsset: (name, asset, base=Assets) ->
            if not base[name]?
                base[name] = {}
            base[name][asset.displayName] = asset

            return asset

        makeAssets: (name, assetObject, base=Assets) ->
            if not base[name]?
                base[name] = {}
            for k, v of assetObject
                base[name][k] = v

            return assetObject

        exposeAsset: (name, cl, base=Assets, m) ->
            @makeAsset(name, cl, base)
            return TypeSystem.makeTypeSingle(name, cl)

        exposeAssets: (name, assetObject, base=Assets) ->
            @makeAssets(name, assetObject, base)
            return TypeSystem.makeType(name, assetObject)
    }
