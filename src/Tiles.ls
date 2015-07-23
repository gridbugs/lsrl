export const TileTypes =
    \GRASS
    \STONE
    \DIRT
    \TREE
    \DEAD_TREE
    \WATER
    \WALL
    \WOODEN_BRIDGE
    \STONE_BRIDGE
    \WOODEN_DOOR
    \STONE_DOOR

export Tiles = {}
let i = 0
    for t in TileTypes
        Tiles[t] = i++

