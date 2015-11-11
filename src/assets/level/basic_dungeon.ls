define [
    'system/level'
    'assets/assets'
    'asset_system'
    'types'
    'config'
], (Level, Assets, AssetSystem, Types, Config) ->

    class BasicDungeon extends Level

        (@width = Config.DEFAULT_WIDTH, @height = Config.DEFAULT_HEIGHT) ->
            super()
            @generator = new Assets.Generator.Castle()

        populate: ->

    AssetSystem.exposeAsset('Level', BasicDungeon)

