define [
    'structures/avl_tree'
    'structures/group_tree'
    'structures/linked_list'
    'debug'
], (AvlTree, GroupTree, LinkedList, Debug) ->

    class ItemCollection
        ->
            @items = new GroupTree.GroupTree(new AvlTree.AvlTree(), LinkedList.LinkedList)

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
            items.forEach (item) ~>
                @insertItem(item)

        forEachItem: (f) -> @items.forEach(f)
        forEachItemType: (f) -> @items.forEachGroupPair(f)

        removeItem: (item) ->
            ret = @items.deleteByKey(item.getGroupId())
            @postRemoveItem(ret)
            return ret

        removeItems: (type, amount) ->
            ret = @items.deleteAmountByKey(type, amount)
            for r in ret
                @postRemoveItem(r)
            return ret

    {
        ItemCollection
    }
