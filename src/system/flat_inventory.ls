define [
    'structures/heap'
    'debug'
], (Heap, Debug) ->

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
                @freeLetters.insert(String.fromCharCode('a'.charCodeAt(0) + i))

            @items = {}
            @numItems = 0

        addItem: (item) ->
            letter = @freeLetters.pop()
            if letter?
                @items[letter] = item
                ++@numItems
                return true
            else
                return false

        isFull: ->
            return @freeLetters.empty()

        isEmpty: ->
            return @numItems == 0

        getItemCount: -> @numItems

        removeItemByLetter: (letter) ->
            item = @items[letter]
            if item?
                delete @items[letter]
                @freeLetters.insert(letter)
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
            for _, item of @items
                if item?
                    f(item)

        forEachMapping: (f) ->
            for letter, item of @items
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
            
