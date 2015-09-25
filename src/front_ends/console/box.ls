define [
    'types'
], (Types) ->

    BorderHashes =                  <[ # # # # # # # # ]>
    BorderSingleLineAscii =         <[ - | - | + + + + ]>
    BorderSingleLineUnicode =       <[ ─ │ ─ │ ┐ ┘ └ ┌ ]>
    BorderSingleLineUnicodeBold =   <[ ━ ┃ ━ ┃ ┓ ┛ ┗ ┏ ]>

    forEachIndexAtBorder = (width, height, f) ->
        forEachIndexAtDepth(width, height, 0, f)

    forEachIndexAtDepth = (width, height, d, f) ->
        # north west corner
        f(d, d, Types.Direction.NorthWest)

        # north
        for i from 1 + d til width - 1 - d
            f(i, d, Types.Direction.North)

        # north east corner
        f(width - 1 - d, d, Types.Direction.NorthEast)

        # east
        for i from 1 + d til height - 1 - d
            f(width - 1 - d, i, Types.Direction.East)

        # south east corner
        f(width - 1 - d, height - 1 - d, Types.Direction.SouthEast)

        # south
        for i from width - 2 - d to 1 + d by -1
            f(i, height - 1 - d, Types.Direction.South)

        # south west corner
        f(d, height - 1 - d, Types.Direction.SouthWest)

        # west
        for i from height - 2 - d til d by -1
            f(d, i, Types.Direction.West)           

    {
        forEachIndexAtDepth
        forEachIndexAtBorder

        BorderHashes
        BorderSingleLineAscii
        BorderSingleLineUnicode
        BorderSingleLineUnicodeBold
    }
