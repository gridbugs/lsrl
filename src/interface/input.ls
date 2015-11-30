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
            @acceptMouse = true
            key <- @getKey()
            callback(key.getControl())

        getChar: (callback) ->
            @acceptMouse = false
            key <- @getKey()
            callback(key.getChar())
