define [
    'cell/ground'
    'asset_system'
], (Ground, AssetSystem) ->

    class Dirt extends Ground
        ->
            super()

    class Stone extends Ground
        ->
            super()

    class Moss extends Ground
        ->
            super()

    class Grass extends Ground
        ->
            super()

    AssetSystem.exposeAssets 'Ground', {
        Dirt
        Stone
        Moss
        Grass
    }
