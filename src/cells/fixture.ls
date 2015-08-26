define [
    'types'
    'actions/effect'
], (Types, Effect) ->

    class Fixture extends Effect.Effectable
        (@type) ->

    class Null extends Fixture
        (cell) ->
            super Types.Fixture.Null
            @effects = []

        getName: -> 'Null'

    class Wall extends Fixture
        (cell) ->
            super Types.Fixture.Wall
            @effects = [
                new Effect.CellIsSolid cell
            ]
        getName: -> 'Wall'

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
    }
