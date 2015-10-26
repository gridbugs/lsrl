define [
    'cell/feature'
    'assets/effects/effects'
    'type_system'
    'util'
], (Feature, Effects, TypeSystem, Util) ->

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

    Util.mergeObjects Feature.DebugFeatures, TypeSystem.makeType 'Feature', {
        Wall
        Door
        Tree
        Null: Feature.NullFeature
    }
