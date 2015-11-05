define [
    'system/level'
    'assets/assets'
    'asset_system'
    'types'
    'config'
], (Level, Assets, AssetSystem, Types, Config) ->

    class Start extends Level
        (@width = Config.DEFAULT_WIDTH, @height = Config.DEFAULT_HEIGHT) ->
            @generator = new Assets.Generator.Surface()

        populate: ->

            pc = new Assets.Character.Human(pos, @grid, Assets.Controller.PlayerController)

            @grid.forEach (c) ->
                if c.feature.type == Types.Feature.Null and Math.random() < 0.01
                    @addCharacter(new Assets.Character.Spider(c.position, grid, Assets.Controller.SpiderController))
                    c.feature = new Assets.Feature.Web(c)

    AssetSystem.exposeAsset('Level', Start)

