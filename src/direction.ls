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
    const CardinalDirections = <[NORTH EAST SOUTH WEST]> |> map (n) -> Directions[n]
    const OrdinalDirections = <[NORTHEAST SOUTHEAST SOUTHWEST NORTHWEST]> |> map (n) -> Directions[n]

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
        AllDirections
        CardinalDirections
        OrdinalDirections
        N_DIRECTIONS
        N_CARDINAL_DIRECTIONS
        N_ORDINAL_DIRECTIONS
        DirectionVectorsByIndex
    }
