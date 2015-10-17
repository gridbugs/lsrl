define [
    'assets/characters/shrubberies'
    'assets/characters/human'
    'assets/generators/catacombs'
    'assets/generators/castle'
    'assets/generators/surface'
    'assets/tile_schemes/default'
], (Shrubberies, Human, Catacombs, Castle, Surface, DefaultTileScheme) ->
    {
        Characters: {
            Shrubberies
            Human
        },
        Generators: {
            Catacombs
            Castle
            Surface
        },
        TileSchemes: {
            Default: DefaultTileScheme
        }
    }
