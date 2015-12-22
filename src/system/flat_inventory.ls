define [
    'structures/heap'
    'structures/avl_tree'
    'util'
    'debug'
], (Heap, AvlTree, Util, Debug) ->

    class ItemSlot
        (@inventory, @key, @item) ->

        removeItem: ->
            removed = @inventory.removeItemByLetter(@key)
            Debug.assert(removed == @item)
            return @item

    class FlatInventory
        (@numSlots = 26) ->
            @freeLetters = new Heap()
            for i from 0 til @numSlots
                @freeLetters.insert(Util.getNthLetter(i))

            @items = {}
            @numItems = 0
            @activeLetters = new AvlTree()

        addItem: (item) ->
            letter = @allocateLetter()
            if letter?
                @items[letter] = item
                ++@numItems
                return letter
            else
                return void

        isFull: ->
            return @freeLetters.empty()

        isEmpty: ->
            return @numItems == 0

        getItemCount: -> @numItems

        allocateLetter: ->
            letter = @freeLetters.pop()
            @activeLetters.insert(letter)
            return letter

        deallocateLetter: (letter) ->
            @freeLetters.insert(letter)
            @activeLetters.deleteByKey(letter)

        removeItemByLetter: (letter) ->
            item = @items[letter]
            if item?
                delete @items[letter]
                @deallocateLetter(letter)
                --@numItems
            return item

        getItemByLetter: (letter) ->
            return @items[letter]

        getSlotByLetter: (letter) ->
            item = @getItemByLetter(letter)
            if item?
                return new ItemSlot(this, letter, item)
            else
                return void

        forEach: (f) ->
            @activeLetters.forEachKey (letter) ~>
                item = @items[letter]
                if item?
                    f(item)

        forEachMapping: (f) ->
            @activeLetters.forEachKey (letter) ~>
                item = @items[letter]
                if item?
                    f(letter, item)

        getAny: ->
            for _, item of @items
                if item?
                    return item
            return void

        getAnySlot: ->
            for key, item of @items
                if item?
                    return new ItemSlot(this, key, item)
            return void

