define [
    'system/level'
    'assets/assets'
    'asset_system'
    'types'
    'config'
], (Level, Assets, AssetSystem, Types, Config) ->

    class SimpleDungeonTop extends Level

        (@gameState, @depth = 1, @width = Config.DEFAULT_WIDTH, @height = Config.DEFAULT_HEIGHT) ->
            super(@gameState)
            @generator = new Assets.Generator.Castle()

        generate: ->
            child = @createChild(new Assets.Level.SimpleDungeonIntermediate(@gameState, @depth + 1))
            child.createConnections(
                1,
                Assets.Feature.StoneDownwardStairs,
                Assets.Feature.StoneUpwardStairs
            )
            child.level.addConnections(child.connections)
            @fromConnections = child.connections

            super()

        populate: ->
            @addDefaultPlayerCharacter()

    AssetSystem.exposeAsset('Level', SimpleDungeonTop)
