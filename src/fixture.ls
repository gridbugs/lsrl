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

    {
        Null
        Wall
    }
