define [\util, \vec2, 'prelude-ls'], (util, vec2, prelude) ->

    map = prelude.map


    class Direction
        (@index, @name) ~>
        toString: -> "#{@name} #{@index}"

    const DirectionNames =
        \NORTH
        \EAST
        \SOUTH
        \WEST
        \NORTHEAST
        \SOUTHEAST
        \SOUTHWEST
        \NORTHWEST

    Directions = {}
    Indices = {}

    i = 0
    for n in DirectionNames
        Indices[n] = i
        Directions[n] = Direction i, n
        ++i


    const AllDirections = DirectionNames |> map (n) -> Directions[n]
    const CardinalDirectionNames = <[NORTH EAST SOUTH WEST]>
    const OrdinalDirectionNames = <[NORTHEAST SOUTHEAST SOUTHWEST NORTHWEST]>
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
        vec2.Vec2 0, -1
        vec2.Vec2 1, 0
        vec2.Vec2 0, 1
        vec2.Vec2 -1, 0
        vec2.Vec2 1, -1
        vec2.Vec2 1, 1
        vec2.Vec2 -1, 1
        vec2.Vec2 -1, -1

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
    }
