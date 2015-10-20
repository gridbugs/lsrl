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
                v.prototype.type = i
                v.prototype.typeName = k
                ++i
            Types[name] = type

            return object
    }
