define [
    \tree_wrapper
    \debug
], (TreeWrapper, Debug) ->

    class GroupTree extends TreeWrapper.TreeWrapper
        (@tree) ->
            super ...
            @length = 0

        top: -> (super())?[0]

        insert: (key, value) ->
            ++@length
            existing = @findGroupByKey(key)
            if existing?
                existing.push(value)
            else
                super(key, [value])

        insertGroup: (key, group) ->
            @length += group.length
            existing = @findGroupByKey(key)
            if existing?
                for x in group
                    existing.push(x)
            else
                super(key, group)

        findGroupByKey: (key) -> @tree.findByKey(key)

        deleteGroupByKey: (key) ->
            ret = @tree.deleteByKey(key)
            if ret?
                @length -= ret.length

            Debug.assert(not @tree.containsKey(key), "Delete didn't work.")

            return ret

        forEach: (f) ->
            super (group) ->
                for x in group
                    f(x)

        forEachPair: (f) ->
            super (key, group) ->
                for x in group
                    f(key, x)

        forEachGroup: (f) -> @tree.forEach(f)
        forEachGroupPair: (f) -> @tree.forEachPair(f)

        deleteAmountByKey: (key, amount) ->
            array = @findGroupByKey(key)
            if array?
                Debug.assert(array.length > 0, "Array is empty")
                ret = array.splice(array.length - amount)
                if array.length == 0
                    @deleteGroupByKey(key)

                @length -= ret.length
                return ret
            else
                return void

        findByKey: (key) ->
            array = @findGroupByKey(key)
            if array?
                Debug.assert(array.length > 0, "Array is empty")
                return array[0]
            else
                return void

        deleteByKey: (key) ->
            array = @findGroupByKey(key)
            if array?
                Debug.assert(array.length > 0, "Array is empty")
                ret = array.pop()
                if array.length == 0
                    @deleteGroupByKey(key)

                --@length
                return ret
            else
                return void

    {
        GroupTree
    }

