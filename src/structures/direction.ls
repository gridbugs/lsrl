define [
    'types'
    'structures/vec2'
    'util'
], (Types, Vec2, Util) ->

    const CardinalDirectionNames = <[North East South West]>
    const OrdinalDirectionNames = <[NorthEast SouthEast SouthWest NorthWest]>

    const DirectionNames = Util.enumKeys Types.Direction
    getName = (d) -> DirectionNames[d]

    const Directions = Util.enumValues Types.Direction
    const CardinalDirections = Util.enumValuesForKeys Types.Direction, CardinalDirectionNames
    const OrdinalDirections = Util.enumValuesForKeys Types.Direction, OrdinalDirectionNames

    const NumDirections = Directions.length
    const NumCardinalDirections = CardinalDirections.length
    const NumOrdinalDirections = OrdinalDirections.length

    const FrontSides = Util.joinArraySelf Types.Direction, {
        North: [\NorthWest, \NorthEast, \West, \East]
        East: [\North, \NorthEast, \South, \SouthEast]
        South: [\West, \East, \SouthWest, \SouthEast]
        West: [\NorthWest, \North, \SouthWest, \South]
        NorthEast: [\NorthWest, \North, \East, \SouthEast]
        SouthEast: [\NorthEast, \East, \South, \SouthWest]
        SouthWest: [\SouthEast, \South, \West, \NorthWest]
        NorthWest: [\SouthWest, \West, \North, \NorthEast]
    }
    const Fronts = Util.joinArraySelf Types.Direction, {
        North: [\NorthWest, \NorthEast, \North]
        East: [\NorthEast, \SouthEast, \East]
        South: [\SouthWest, \SouthEast, \South]
        West: [\NorthWest, \SouthWest, \West]
        NorthEast: [\North, \East, \NorthEast]
        SouthEast: [\East, \South, \SouthEast]
        SouthWest: [\South, \West, \SouthWest]
        NorthWest: [\West, \North, \NorthWest]
    }
    const CardinalMap = Util.table Types.Direction, {
        North: true
        South: true
        East: true
        West: true
        NorthEast: false
        SouthEast: false
        NorthWest: false
        SouthWest: false
    }
    const OrdinalMap = Util.table Types.Direction, {
        North: false
        South: false
        East: false
        West: false
        NorthEast: true
        SouthEast: true
        NorthWest: true
        SouthWest: true
    }

    isOrdinal = (d) -> OrdinalMap[d]
    isCardinal = (d) -> CardinalMap[d]

    const Vectors = [
        new Vec2(0, -1),
        new Vec2(1, 0),
        new Vec2(0, 1),
        new Vec2(-1, 0),
        new Vec2(1, -1),
        new Vec2(1, 1),
        new Vec2(-1, 1),
        new Vec2(-1, -1)
    ]

    {
        /* Lists of directions */
        Directions
        CardinalDirections
        OrdinalDirections

        /* Mappings from one direction to related directions */
        Fronts
        FrontSides

        /* Predicates on directions */
        isOrdinal
        isCardinal

        /* Useful mappings from directions */
        Vectors

        /* Useful constants */
        NumDirections
        NumCardinalDirections
        NumOrdinalDirections

        /* Useful functions */
        getName
    }
