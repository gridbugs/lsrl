define [
    'cell/feature'
    'assets/action/action'
    'assets/effect/reactive_effect'
    'asset_system'
    'util'
    'types'
], (Feature, Actions, Effects, AssetSystem, Util, Types) ->

    class SolidFeature extends Feature
        ->
            super()
            @solid = new Effects.Solid()

        notify: (action, relationship, game_state) ->
            @solid.notify(action, relationship, game_state)
            @notifyRegisteredEffects()


    class Wall extends SolidFeature
        ->
            super()

        getOpacity: ->
            return 1

    class Door extends Feature
        (@_isOpen = false) ->
            super()
            @solid = new Effects.Solid()

        isOpen: -> @_isOpen
        isClosed: -> not @_isOpen
        open: -> @_isOpen = true
        close: -> @_isOpen = false

        notify: (action, relationship, game_state) ->
            if not @isOpen()
                @solid.notify(action, relationship, game_state)
            @notifyRegisteredEffects()

        getOpacity: ->
            if @isOpen()
                return 0
            else
                return 1

        isSolid: ->
            return @isClosed()

    class Tree extends SolidFeature
        ->
            super()

        getOpacity: ->
            return 0.5

    class Water extends SolidFeature
        ->
            super()

        getOpacity: ->
            return 0

        isSolid: ->
            return true

    class Bridge extends Feature
        ->
            super()

        getOpacity: ->
            return 0

        isSolid: ->
            return false

    class StoneDownwardStairs extends Feature
        ->
            super()

        getOpacity: ->
            return 0

        isSolid: ->
            return false

    class Web extends Feature
        (@cell) ->
            super()
            @strength = Util.getRandomInt(3, 6)

        getOpacity: ->
            return 0.3

        isSolid: ->
            return false

        isBenign: ->
            return false

        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Move and relationship == action.Relationships.SourceCell
                action.success = false
                game_state.enqueueAction(new Actions.StruggleInWeb(action.character, @cell))
            else if action.type == Types.Action.StruggleInWeb and relationship == action.Relationships.Cell and @strength == 0
                action.success = false
                game_state.enqueueAction(new Actions.BreakWeb(action.character, @cell))
            @notifyRegisteredEffects()

        weaken: ->
            --@strength

        break: ->
            @cell.feature = new Feature.NullFeature()

    AssetSystem.exposeAssets 'Feature', Util.mergeObjects Feature.DebugFeatures, {
        Wall
        Door
        Tree
        Water
        Bridge
        StoneDownwardStairs
        Web
        Null: Feature.NullFeature
    }
