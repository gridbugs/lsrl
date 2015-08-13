define [\util, \vec2, 'prelude-ls'], (Util, Vec2, Prelude) ->

    map = Prelude.map


    class Direction
        (@index, @name) ~>
        toString: -> "#{@name} #{@index}"

    const DirectionNames =
        \North
        \East
        \South
        \West
        \NorthEast
        \SouthEast
        \SouthWest
        \NorthWest

    Directions = {}
    Indices = {}

    i = 0
    for n in DirectionNames
        Indices[n] = i
        Directions[n] = Direction i, n
        ++i

    const AllDirections = DirectionNames |> map (n) -> Directions[n]
    const CardinalDirectionNames = <[North East South West]>
    const OrdinalDirectionNames = <[NorthEast SouthEast SouthWest NorthWest]>
    const CardinalDirections = CardinalDirectionNames |> map (n) -> Directions[n]
    const OrdinalDirections = OrdinalDirectionNames |> map (n) -> Directions[n]

    CardinalIndices = {}
    OrdinalIndices = {}
    for i from 0 til 4
        CardinalIndices[CardinalDirectionNames[i]] = i
        OrdinalIndices[OrdinalDirectionNames[i]] = i


    const N_DIRECTIONS = 8
    const N_CARDINAL_DIRECTIONS = 4
    const N_ORDINAL_DIRECTIONS = 4

    const DirectionVectorsByIndex =
        Vec2.Vec2 0, -1
        Vec2.Vec2 1, 0
        Vec2.Vec2 0, 1
        Vec2.Vec2 -1, 0
        Vec2.Vec2 1, -1
        Vec2.Vec2 1, 1
        Vec2.Vec2 -1, 1
        Vec2.Vec2 -1, -1

    const DirectionEnum = Util.enum DirectionNames
    const FrontSides = Util.table DirectionEnum, {
        North: [\NorthWest, \NorthEast, \West, \East] |> map (DirectionEnum.)
        East: [\North, \NorthEast, \South, \SouthEast] |> map (DirectionEnum.)
        South: [\West, \East, \SouthWest, \SouthEast] |> map (DirectionEnum.)
        West: [\NorthWest, \North, \SouthWest, \South] |> map (DirectionEnum.)
        NorthEast: [\NorthWest, \North, \East, \SouthEast] |> map (DirectionEnum.)
        SouthEast: [\NorthEast, \East, \South, \SouthWest] |> map (DirectionEnum.)
        SouthWest: [\SouthEast, \South, \West, \NorthWest] |> map (DirectionEnum.)
        NorthWest: [\SouthWest, \West, \North, \NorthEast] |> map (DirectionEnum.)
    }
    const Fronts = Util.table DirectionEnum, {
        North: [\NorthWest, \NorthEast, \North] |> map (DirectionEnum.)
        East: [\NorthEast, \SouthEast, \East] |> map (DirectionEnum.)
        South: [\SouthWest, \SouthEast, \South] |> map (DirectionEnum.)
        West: [\NorthWest, \SouthWest, \West] |> map (DirectionEnum.)
        NorthEast: [\North, \East, \NorthEast] |> map (DirectionEnum.)
        SouthEast: [\East, \South, \SouthEast] |> map (DirectionEnum.)
        SouthWest: [\South, \West, \SouthWest] |> map (DirectionEnum.)
        NorthWest: [\West, \North, \NorthWest] |> map (DirectionEnum.)
    }
    const cardinalMap = Util.table DirectionEnum, {
        North: true
        South: true
        East: true
        West: true
        NorthEast: false
        SouthEast: false
        NorthWest: false
        SouthWest: false
    }
    const ordinalMap = Util.table DirectionEnum, {
        North: false
        South: false
        East: false
        West: false
        NorthEast: true
        SouthEast: true
        NorthWest: true
        SouthWest: true
    }

    isOrdinal = (d) -> ordinalMap[d]
    isCardinal = (d) -> cardinalMap[d]

    const AllIndices = [0 til N_DIRECTIONS]

    {
        Directions
        Indices
        CardinalIndices
        OrdinalIndices
        AllDirections
        CardinalDirections
        OrdinalDirections
        N_DIRECTIONS
        N_CARDINAL_DIRECTIONS
        N_ORDINAL_DIRECTIONS
        DirectionVectorsByIndex
        FrontSides
        Fronts
        isOrdinal
        isCardinal
        DirectionEnum
        AllIndices
    }
