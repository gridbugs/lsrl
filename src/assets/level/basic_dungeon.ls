define [
    'system/level'
    'assets/assets'
    'asset_system'
    'types'
    'config'
], (Level, Assets, AssetSystem, Types, Config) ->

    class BasicDungeon extends Level

        (@gameState, @width = Config.DEFAULT_WIDTH, @height = Config.DEFAULT_HEIGHT) ->
            super(@gameState)
            @generator = new Assets.Generator.Castle()

        populate: ->
            @addDefaultPlayerCharacter()

    AssetSystem.exposeAsset('Level', BasicDungeon)

