define [
], ->

    class InputSource
        ->
            @currentCallback = void
            @native = false

        getKey: (callback) ->
            @dirty = false
            @currentCallback = callback

        getControl: (callback) ->
            key <- @getKey()
            callback(key.getControl())

        getChar: (callback) ->
            key <- @getKey()
            callback(key.getChar())
