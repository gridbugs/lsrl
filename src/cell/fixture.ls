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
    }, {[char, debugFixture(char)] for char in Debug.chars}
