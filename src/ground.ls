define [
    \effect
], (Effect) ->

    class Ground extends Effect.Effectable

    class Dirt extends Ground
        -> @effects = []

    class Stone extends Ground
        -> @effects = []

    {
        Dirt
        Stone
    }
