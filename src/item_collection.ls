define [
    \avl_tree
    \group_tree
    \debug
], (AvlTree, GroupTree, Debug) ->

    class ItemCollection
        ->
            @items = new GroupTree.GroupTree(new AvlTree.AvlTree())

        length: -> @items.length

        first: ->
            @items.top()

        empty: ->
            @items.empty()

        preAddItem: (item) ->
            Debug.assert(item.collection == void, "Item is already in a collection. Remove it first!")
            item.collection = this

        postRemoveItem: (item) ->
            item.collection = void

        insertItem: (item) ->
            @preAddItem(item)
            @items.insert(item.getGroupId(), item)

        insertItems: (items) ->
            if items.length > 0
                key = items[0].getGroupId()
                for i in items
                    @preAddItem(i)
                    Debug.assert(i.getGroupId() == key)

                @items.insertGroup(key, items)

        forEachItem: (f) -> @items.forEach(f)
        forEachItemType: (f) -> @items.forEachGroupPair(f)

        removeItem: (item) ->
            ret = @items.deleteByKey(item.getGroupId())
            @postRemoveItem(item)
            return ret

        removeItems: (type, amount) ->
            ret = @items.deleteAmountByKey(type, amount)
            for r in ret
                @postRemoveItem(r)
            return ret

    {
        ItemCollection
    }
