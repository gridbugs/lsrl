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

