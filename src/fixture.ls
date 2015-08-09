define [
    \effect
], (Effect) ->
    
    class Fixture extends Effect.Effectable

    class Null extends Fixture
        (cell) -> @effects = []

    class Wall extends Fixture
        (cell) ->
            @effects = [
                new Effect.CellIsSolid cell
            ]

    class Web extends Fixture
        (@cell) ->
            @strength = 3
            @effects = [
                new Effect.CellIsSticky cell, this
            ]

        tryUnstick: ->
            --@strength

        unstick: ->
            @cell.setFixture Null

    class Tree extends Fixture
        (cell) ->
    {
        Null
        Wall
        Web
        Tree
    }
