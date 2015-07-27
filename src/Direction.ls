require! './Util.ls'
require! './Vec2.ls': {vec2}

export const DirectionNames =
    \NORTH
    \EAST
    \SOUTH
    \WEST
    \NORTHEAST
    \SOUTHEAST
    \SOUTHWEST
    \NORTHWEST

export const Directions = Util.makeEnum DirectionNames

export const NORTH = 0
export const EAST = 1
export const SOUTH = 2
export const WEST = 3
export const NORTHEAST = 4
export const SOUTHEAST = 5
export const SOUTHWEST = 6
export const NORTHWEST = 7

export const directions = [NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST]
export const cardinalDirections = [NORTH, EAST, SOUTH, WEST]
export const ordinalDirections = [NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST]

export const N_DIRECTIONS = 8
export const N_CARDINAL_DIRECTIONS = 4
export const N_ORDINAL_DIRECTIONS = 4

export const directionNames = <[ north east south west northeast southeast southwest northwest ]>

export const directionVectors =
    vec2 0, -1
    vec2 1, 0
    vec2 0, 1
    vec2 -1, 0
    vec2 1, -1
    vec2 1, 1
    vec2 -1, 1
    vec2 -1, -1
