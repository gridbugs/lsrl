define [
    'assets/characters/shrubberies'
    'assets/characters/human'
    'assets/generators/catacombs'
], (Shrubberies, Human, Catacombs) ->
    {
        Characters: {
            Shrubberies
            Human
        },
        Generators: {
            Catacombs
        }
    }
