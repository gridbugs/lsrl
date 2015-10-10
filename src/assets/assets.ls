define [
    'assets/characters/shrubberies'
    'assets/characters/human'
    'assets/generators/catacombs'
    'assets/generators/castle'
    'assets/generators/surface'
], (Shrubberies, Human, Catacombs, Castle, Surface) ->
    {
        Characters: {
            Shrubberies
            Human
        },
        Generators: {
            Catacombs
            Castle
            Surface
        }
    }
