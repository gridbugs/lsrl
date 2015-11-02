define [
    'system/description'
    'assets/assets'
    'system/cell'
    'system/knowledge'
    'asset_system'
    'types'
], (Description, Assets, Cell, Knowledge, AssetSystem, Types) ->
    AssetSystem.makeAsset 'Describer', {
        displayName: 'English'
        init: ->
            style = {}
            for k, v of Description.StyleFunctions
                style[k] = v

            return style

        install: ->
            style = @init()

            Cell::describe = ->
                if @character? and @character.describe?
                    return @character.describe()
                else if @feature.type != Types.Feature.Null and @feature.describe?
                    return @feature.describe()
                else
                    return @ground.describe()

            Knowledge.KnowledgeCell::describe = ->
                return @gameCell.describe()


            Assets.Ground.Grass::describe = ->
                return new Description(['grass covered ground'])

            Assets.Ground.Stone::describe = ->
                return new Description(['stone floor'])

            Assets.Ground.Dirt::describe = ->
                return new Description(['a bare patch of dirt'])

            Assets.Ground.Moss::describe = ->
                return new Description(['moss covered floor'])

            Assets.Feature.Tree::describe = ->
                return new Description(['a tree'])

            Assets.Feature.Water::describe = ->
                return new Description(['water'])

            Assets.Feature.Wall::describe = ->
                return new Description(['a stone wall'])

            Assets.Feature.StoneDownwardStairs::describe = ->
                return new Description(['a stone staircase leading downwards'])

            Assets.Character.Spider::describe = ->
                return new Description(['spider'])

            Assets.Character.Human::describe = ->
                return new Description(['human'])

            Assets.ContinuousEffect.Poisoned::describe = ->
                return new Description([style.purple(["Poisoned: #{@remainingTime}"])])

        installPlayerCharacter: (pc) ->
            pc.describe = ->
                return new Description(['you'])
                
    }
