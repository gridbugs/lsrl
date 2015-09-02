define [
    'structures/tree_wrapper'
    'functional'
    'debug'
], (TreeWrapper, Functional, Debug) ->

    class GroupTree extends TreeWrapper.TreeWrapper
        (@tree, @C) ->
            super ...
            @length = 0

        top: -> super()?.first()

        numGroups: -> @tree.length

        withExisting: (key, onTrue, onFalse) ->
            Functional.ifExists(@~findGroupByKey, key, onTrue, onFalse)

        insert: (key, value, callback) ->
            ++@length
            ret = void

            @withExisting key, (existing) ->
                existing.push(value)
                ret := existing
            , ~> #else
                group = new @C()
                    ..push(value)
                super(key, group)
                ret := group

            Debug.assert(ret?, "cannot return null")
            callback?(ret)
            return ret

        insertGroup: (key, group, callback) ->
            @length += group.length()
            ret = void

            @withExisting key, (existing) ->
                existing.extend(group)
                ret := existing
            , ~> #else
                copy = new @C()
                    ..extend(group)
                super(key, copy)

            Debug.assert(ret?, "cannot return null")
            callback?(ret)
            return ret

        findGroupByKey: (key, f) ->
            return @tree.findByKey(key, f)

        deleteGroupByKey: (key, callback) ->
            ret = void
            do
                value <~ @tree.deleteByKey(key)
                callback?(value)
                ret := value
                @length -= ret.length()
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

        deleteAmountByKey: (key, amount, callback) ->
            ret = void

            @withExisting key, (existing) ~>
                Debug.assert(existing.length() > 0, "Group is empty")
                ret := existing.take(amount)
                callback?(ret)

                if existing.length() == 0
                    @deleteGroupByKey(key)

                @length -= ret.length()

            return ret

        deleteAmountFromGroup: (group, key, amount) ->
            ret = group.take(amount)
            @length -= ret.length()
            if group.length() == 0
                @deleteGroupByKey(key)

            return ret

        findByKey: (key, callback) ->
            ret = void
            do
                group <~ @findGroupByKey(key)
                Debug.assert(group.length() > 0, "Group is empty")
                ret := group.first()
                callback(ret)
            return ret

        deleteByKey: (key, callback) ->
            ret = void

            @withExisting key, (existing) ~>
                Debug.assert(existing.length() > 0, "Group is empty")
                ret := existing.pop()
                if existing.length() == 0
                    @deleteGroupByKey(key)

                --@length

            return ret

    {
        GroupTree
    }

