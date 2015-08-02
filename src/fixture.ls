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
            if @strength == 0
                @cell.fixture = new Null @cell

    {
        Null
        Wall
        Web
    }
