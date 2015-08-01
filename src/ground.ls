define [
    \effect
], (Effect) ->

    class Ground extends Effect.Effectable

    class Dirt extends Ground
        -> @effects = []

    {
        Dirt
    }
