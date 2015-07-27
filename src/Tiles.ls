require! './Util.ls'

export const TileNames =
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

export Tiles = Util.makeEnum TileNames
