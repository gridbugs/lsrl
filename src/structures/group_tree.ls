define [
    'structures/tree_wrapper'
    'debug'
], (TreeWrapper, Debug) ->

    class GroupTree extends TreeWrapper.TreeWrapper
        (@tree, @C) ->
            super ...
            @length = 0

        top: -> super()?.first()

        insert: (key, value) ->
            ++@length
            existing = @findGroupByKey(key)
            if existing?
                existing.push(value)
                return existing
            else
                group = new @C()
                group.push(value)
                super(key, group)
                return group

        insertGroup: (key, group) ->
            @length += group.length()
            existing = @findGroupByKey(key)
            if existing?
                existing.extend(group)
            else
                copy = new @C()
                copy.extend(group)
                super(key, copy)

        findGroupByKey: (key) ->
            ret = @tree.findByKey(key)
            return ret

        deleteGroupByKey: (key) ->
            ret = @tree.deleteByKey(key)
            if ret?
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

        deleteAmountByKey: (key, amount) ->
            group = @findGroupByKey(key)
            if group?
                Debug.assert(group.length() > 0, "Group is empty")
                ret = group.take(amount)
                if group.length() == 0
                    @deleteGroupByKey(key)

                @length -= ret.length()
                return ret
            else
                return void

        findByKey: (key) ->
            group = @findGroupByKey(key)
            if group?
                Debug.assert(group.length() > 0, "Group is empty")
                return group.first()
            else
                return void

        deleteByKey: (key) ->
            group = @findGroupByKey(key)
            if group?
                Debug.assert(group.length() > 0, "Group is empty")
                ret = group.pop()
                if group.length() == 0
                    @deleteGroupByKey(key)

                --@length
                return ret
            else
                return void

    {
        GroupTree
    }

