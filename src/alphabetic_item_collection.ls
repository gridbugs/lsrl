define [
    \util
    \debug
], (Util, Debug) ->

    DefaultCharacters = 'abcdefg'

    class AlphabeticItemCollection
        (@itemCollection) ->
            @characters = DefaultCharacters
            @map = Util.objectKeyedByArray(@characters)
            @itemCollection.forEachItemType (type, group) ~>
                @fillFreeSlot(type)

        fillFreeSlot: (value) ->
            key = @getFreeKey()
            @map[key] = value

        getFreeKey: ->
            for k in @characters
                v = @map[k]
                if not v?
                    return k
            Debug.assert(false, "Out of slots!")

        getKeyWithValue: (value) ->
            for k in @characters
                v = @map[k]
                if v == value
                    return k
            return void

        clearSlot: (key) ->
            @map[key] = void

        insertItem: (item) ->
            item_key = item.getGroupId()
            ret = void
            if not @itemCollection.items.containsKey(item_key)
                ret = @getFreeKey()
                @map[ret] = item_key
            else
                ret = @getKeyWithValue(item_key)

            @itemCollection.insertItem(item)
            return ret

        removeItem: (item) ->
            ret = @itemCollection.removeItem(item)
            item_key = item.getGroupId()
            if not @itemCollection.items.containsKey(item_key)
                @clearSlot(@getKeyWithValue(item_key))
            return ret

        forEachMapping: (f) ->
            for k in @characters
                v = @map[k]
                if v?
                    f(k, @itemCollection.items.findGroupByKey(v))

        getGroupByChar: (c) ->
            key = @map[c]
            if key?
                return @itemCollection.items.findGroupByKey(@map[c])
            else
                return void

    {
        AlphabeticItemCollection
    }
