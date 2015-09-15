define [
    'types'
    'action/effect'
    'action/effectable'
], (Types, Effect, Effectable) ->

    class Ground extends Effectable
        (@type) ->
            super()

    class Dirt extends Ground
        ->
            super(Types.Ground.Dirt)

        getName: -> 'Dirt'

    class Stone extends Ground
        ->
            super(Types.Ground.Stone)

        getName: -> 'Stone'

    class Moss extends Ground
        ->
            super(Types.Ground.Moss)

        getName: -> 'Moss'

    {
        Dirt
        Stone
        Moss
    }
