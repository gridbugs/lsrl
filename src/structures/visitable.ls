define [
], -> 
    {
        _visited: false
        visit: !->
            @_visited = true
        unvisit: !->
            @_visited = false
            @_parent = void
        isVisited: !->
            return @_visited

        _parent: void
        hasParent: !->
            return @_parent?
        setParent: (p) !->
            @_parent = p
        getParent: !->
            return @_parent
    }
