define [
    'types'
    'actions/effect'
    'actions/effectable'
], (Types, Effect, Effectable) ->

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
            super Types.Fixture.Door
            @effects = [
                new Effect.CellIsOpenable(cell)
            ]
            @_isOpen = false

        open: ->
            @_isOpen = true

        close: ->
            @_isOpen = false

        isOpen: -> @_isOpen

        getName: ->
            if @isOpen
                'Open Door'
            else
                'Closed Door'

    class Web extends Fixture
        (@cell) ->
            super Types.Fixture.Web
            @strength = 3
            @effects = [
                new Effect.CellIsSticky cell, this
            ]
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
