define [
    'types'
], (Types) ->

    {
        makeType: (name, object) ->

            type = Types[name]
            if not type?
                type = {}

            i = 0
            for k, v of object
                type[k] = i
                v::type = i
                v::typeName = k
                ++i
            Types[name] = type

            return object
    }
