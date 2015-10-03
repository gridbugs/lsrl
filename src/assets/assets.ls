define [
    'assets/characters/shrubberies'
    'assets/characters/human'
    'assets/generators/catacombs'
    'assets/generators/castle'
], (Shrubberies, Human, Catacombs, Castle) ->
    {
        Characters: {
            Shrubberies
            Human
        },
        Generators: {
            Catacombs
            Castle
        }
    }
