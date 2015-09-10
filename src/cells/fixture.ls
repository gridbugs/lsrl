define [
    'types'
    'actions/effect'
    'actions/effectable'
    'util'
], (Types, Effect, Effectable, Util) ->

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
            super Types.Fixture.Tree
            @effects = []

        getName: -> 'Tree'
    {
        Null
        Wall
        Web
        Tree
        Door
    }
