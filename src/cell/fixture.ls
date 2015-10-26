define [
    'assets/effects/effects'
    'types'
    'action/effect'
    'action/effectable'
    'util'
    'debug'
], (Effects, Types, Effect, Effectable, Util, Debug) ->

    class Fixture implements Effectable
        (@type) ->
            @effects = []

    class Null extends Fixture
        (cell) ->
            super(Types.Fixture.Null)

        getName: -> 'Null'

    class Wall extends Fixture
        (cell) ->
            super(Types.Fixture.Wall)
            @registerEffect(new Effects.Solid())

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

    class Bridge extends Fixture
        (cell) ->
            super(Types.Fixture.Bridge)

    class StoneDownwardStairs extends Fixture
        (cell) ->
            super(Types.Fixture.StoneDownwardStairs)

    class StoneUpwardStairs extends Fixture
        (cell) ->
            super(Types.Fixture.StoneUpwardStairs)

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
        Bridge,
        StoneDownwardStairs,
        StoneUpwardStairs
    }, {[char, debugFixture(char)] for char in Debug.Chars}
