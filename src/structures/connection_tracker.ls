define [
    'structures/square_table'
], (SquareTable) ->

    class ConnectionTracker
        (@size) ->
            @connections = new SquareTable(@size, -> -1)

            for i from 0 til @size
                @connections.set(i, i, 0)

        connect: (i, j) ->

            @connections.forEachAssoc i, (v, k) ~>
                if v != -1
                    existing = @connections.get(j, k)
                    if existing == -1 or v + 1 < existing
                        @connections.set(j, k, v + 1)

            @connections.forEachAssoc j, (v, k) ~>
                if v != -1
                    existing = @connections.get(i, k)
                    if existing == -1 or v + 1 < existing
                        @connections.set(i, k, v + 1)

            # for each vertex that could be connected to i
            @connections.forEachAssoc i, (v, _j) ~>
                # if the vertex is connected to i
                if v != -1
                    # for each vertex that could be connected to j
                    @connections.forEachAssoc j, (u, _i) ~>
                        # if the vertex is connected to j
                        if u != -1
                            existing = @connections.get(_i, _j)
                            if existing  == -1 or  v + u + 1 < existing
                                @connections.set(_i, _j, v + u + 1)

            @connections.set(i, j, 1)

        isConnected: (i, j) ->
            return @connections.get(i, j) != -1

        getDistance: (i, j) ->
            ret = @connections.get(i, j)
            if ret == -1
                return Infinity
            return ret

