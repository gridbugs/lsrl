define [
    'system/level'
    'assets/assets'
    'asset_system'
    'types'
    'config'
], (Level, Assets, AssetSystem, Types, Config) ->

    class SimpleDungeonIntermediate extends Level

        (@gameState, @depth, @width = Config.DEFAULT_WIDTH, @height = Config.DEFAULT_HEIGHT) ->
            super(@gameState)
            @generator = new Assets.Generator.Castle()

        generate: ->
            if @depth < 5
                child = @createChild(new Assets.Level.SimpleDungeonIntermediate(@gameState, @depth + 1))
            else
                child = @createChild(new Assets.Level.SimpleDungeonBottom(@gameState, @depth + 1))
            child.createConnections(
                1,
                Assets.Feature.StoneDownwardStairs,
                Assets.Feature.StoneUpwardStairs
            )
            child.level.addConnections(child.connections)
            @fromConnections = child.connections

            super()

        populate: ->

    AssetSystem.exposeAsset('Level', SimpleDungeonIntermediate)
