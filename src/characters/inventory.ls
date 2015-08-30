define [
    'structures/group_tree'
    'structures/avl_tree'
    'structures/linked_list'
    'structures/list_wrapper'
    'util'
    'debug'
], (GroupTree, AvlTree, LinkedList, ListWrapper, Util, Debug) ->

    InventoryLetters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

    class InventorySlot extends ListWrapper.ListWrapper
        ->
            @list = new LinkedList.LinkedList()
            @letter = void
            @groupId = void

    class Inventory
        (@letters = InventoryLetters) ->
            @items = new GroupTree.GroupTree(new AvlTree.AvlTree(), InventorySlot)
            @map = Util.objectKeyedByArray(@letters)
            @numSlots = @letters.length

        fillFreeSlot: (value) ->
            letter = @getFreeLetter()
            @fillSlot(letter, value)
            return letter

        fillSlot: (letter, value) ->
            @map[letter] = value

        getSlot: (letter) ->
            @map[letter]

        getFreeLetter: ->
            for k in @letters
                if not @map[k]?
                    return k
            Debug.assert(false, "Out of slots!")
        
        clearSlot: (letter) ->
            @map[letter] = void

        insertItem: (item) ->
            item.collection = this
            key = item.getGroupId()
            group = @items.insert(key, item)
            if not group.letter?
                letter = @getFreeLetter()
                group.letter = letter
                group.groupId = key
                @fillSlot(letter, group)

            return group.letter
        
        insertItems: (items) ->
            ret = void
            items.forEach (item) ~>
                ret := @insertItem(item)

            return ret

        removeItemsByLetter: (letter, num_items) ->
            group = @getSlot(letter)
            return @removeItemsFromGroup(group, num_items)

        removeItemsByGroupId: (id, num_items) ->
            group = @items.findGroupByKey(id)
            return @removeItemsFromGroup(group, num_items)

        removeItemsFromGroup: (group, num_items) ->
            Debug.assert(group.length() > 0, "Group is empty")
            Debug.assert(group.letter?, "Group has no letter")
            ret = group.take(num_items)
            Debug.assert(ret.length() > 0 || num_items == 0, "Ret is empty and num_items is not 0")
            if group.length() == 0
                @items.deleteGroupByKey(group.groupId)
                @clearSlot(group.letter)

            ret.forEach (x) ->
                x.collection = void
            return ret
        
        forEachMapping: (f) ->
            for l in @letters
                v = @map[l]
                if v?
                    f(l, v.list)
        
        getGroupByLetter: (l) ->
            return @map[l]?.list
    {
        Inventory
    }
