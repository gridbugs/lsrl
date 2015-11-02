define [
    'types'
], (Types) ->

    Types.__counts = {}

    {
        makeTypeSingle: (name, cl) ->
            if not Types[name]
                Types[name] = {}
                Types.__counts[name] = 0

            Types[name][cl.displayName] = cl
            ++Types.__counts[name]

            return cl

        makeType: (name, object) ->
            type = Types[name]
            if not type?
                type = {}
                Types.__counts[name] = 0

            i = Types.__counts[name]
            for k, v of object
                type[k] = i
                v::type = i
                v::typeName = k
                ++i
            Types[name] = type
            Types.__counts[name] = i

            return object
    }
