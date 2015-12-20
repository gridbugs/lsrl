define [
    'structures/heap'
], (Heap) ->

    class FlatInventory
        (@numSlots) ->
            @freeLetters = new Heap()
            for i from 0 til @numSlots
                @freeLetters.insert(String.fromCharCode('a'.charCodeAt(0) + i))

            @items = {}

        addItem: (item) ->
            letter = @freeLetters.pop()
            if letter?
                @items[letter] = item
                return true
            else
                return false

        isFull: ->
            return @freeLetters.empty()

        removeItemByLetter: (letter) ->
            item = @items[letter]
            if item?
                @items[letter] = void
                @freeLetters.insert(letter)
            return item

        getItemByLetter: (letter) ->
            return @items[letter]

