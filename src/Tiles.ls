export const TileTypes =
    \GRASS
    \STONE
    \TREE
    \DEAD_TREE
    \WATER
    \WALL

export Tiles = {}
let i = 0
    for t in TileTypes
        Tiles[t] = i++

