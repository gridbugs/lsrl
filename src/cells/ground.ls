define [
    'types'
    'actions/effect'
], (Types, Effect) ->

    class Ground extends Effect.Effectable
        (@type) ->

    class Dirt extends Ground
        ->
            super Types.Ground.Dirt
            @effects = []
        getName: -> 'Dirt'

    class Stone extends Ground
        ->
            super Types.Ground.Stone
            @effects = []
        getName: -> 'Stone'

    class Moss extends Ground
        ->
            super Types.Ground.Moss
            @effects = []
        getName: -> 'Moss'

    {
        Dirt
        Stone
        Moss
    }
