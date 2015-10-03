define [
], ->
    {
        withNeighbour: (idx, callback) ->
            n = @neighbours[idx]
            if n?
                callback(n)

        withNeighbours: (idxs, callback) ->
            for i in idxs
                n = @neighbours[i]
                if n?
                    callback(n, i)
        }
