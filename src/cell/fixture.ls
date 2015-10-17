define [
    'types'
    'action/effect'
    'action/effectable'
    'util'
    'debug'
], (Types, Effect, Effectable, Util, Debug) ->

    class Fixture extends Effectable
        (@type) ->
            super()

    class Null extends Fixture
        (cell) ->
            super(Types.Fixture.Null)

        getName: -> 'Null'

    class Wall extends Fixture
        (cell) ->
            super(Types.Fixture.Wall)
            @addEffect(new Effect.Solid())

        getName: -> 'Wall'

    class BrickWall extends Fixture
        (cell) ->
            super(Types.Fixture.BrickWall)
            @addEffect(new Effect.Solid())

        getName: -> 'Wall'

    class DirtWall extends Fixture
        (cell) ->
            super(Types.Fixture.DirtWall)
            @addEffect(new Effect.Solid())

        getName: -> 'Wall'

    class Door extends Fixture
        (cell) ->
            super(Types.Fixture.Door)
            @addEffect(new Effect.OpenOnEnter())

            @_isOpen = false

        open: ->
            @_isOpen = true

        close: ->
            @_isOpen = false

        isOpen: -> @_isOpen
        isClosed: -> not @isOpen()

        getName: ->
            if @isOpen
                'Open Door'
            else
                'Closed Door'

    class Web extends Fixture
        (@cell) ->
            super(Types.Fixture.Web)
            @strength = Util.getRandomInt(3, 6)

            @addEffect(new Effect.WebEntry())
            @addEffect(new Effect.WebExit())

        getName: -> 'Web'

        tryUnstick: ->
            --@strength

        unstick: ->
            @cell.setFixture Null

    class Tree extends Fixture
        (cell) ->
            super(Types.Fixture.Tree)
            @addEffect(new Effect.Solid())

        getName: -> 'Tree'

    class Water extends Fixture
        (cell) ->
            super(Types.Fixture.Water)
            @addEffect(new Effect.Solid())
            @animationState = Math.random() < 0.5
            @animationCount = Math.floor(Math.random() * 20)

        swapAnimationStates: ->
            @animationState = !@animationState
            @animationCount = Math.floor(Math.random() * 20) + 5

        progress: ->
            --@animationCount
            if @animationCount == 0
                @swapAnimationStates()


    class Bridge extends Fixture
        (cell) ->
            super(Types.Fixture.Bridge)


    debugFixture = (char) ->
        return class extends Fixture
            (cell) ->
                super(Types.Fixture[char])

    Util.mergeObjects {
        Null
        Wall
        Web
        Tree
        Door
        DirtWall
        BrickWall
        Water,
        Bridge
    }, {[char, debugFixture(char)] for char in Debug.Chars}
