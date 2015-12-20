define [
    'system/level'
    'assets/assets'
    'asset_system'
    'types'
    'config'
], (Level, Assets, AssetSystem, Types, Config) ->

    class SimpleDungeonBottom extends Level

        (@gameState, @depth, @width = Config.DEFAULT_WIDTH, @height = Config.DEFAULT_HEIGHT) ->
            super(@gameState)
            @generator = new Assets.Generator.Castle()

        populate: ->

    AssetSystem.exposeAsset('Level', SimpleDungeonBottom)
