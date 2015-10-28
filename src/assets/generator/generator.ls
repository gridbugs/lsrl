define [
    'assets/generator/castle'
    'assets/generator/surface'
    'assets/generator/cave'
    'assets/generator/border'
    'assets/generator/maze'
    'asset_system'
], (Castle, Surface, Cave, Border, Maze, AssetSystem) ->

    AssetSystem.exposeAssets 'Generator', {
        Castle
        Surface
        Cave
        Border
        Maze
    }
