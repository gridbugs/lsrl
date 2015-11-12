define [
    'interface/keymap'
], (Keymap) ->

    class InputSource
        ->
            @currentCallback = void
            @native = false

        getKey: (callback) ->
            @dirty = false
            @currentCallback = callback

        getControl: (callback) ->
            key <- @getKey()
            process.stderr.write('' + key.char + "\n")
            process.stderr.write('' + key.getIndex() + "\n")
            callback(key.getControl())

        getChar: (callback) ->
            key <- @getKey()
            callback(key.getChar())
