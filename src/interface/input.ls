define [
    'interface/keymap'
], (Keymap) ->

    class InputSource
        ->
            @currentCallback = void
            @native = false

        getControl: (cb) ->
            @getChar (c) ->
                cb(Keymap.Controls[c])

        getChar: (cb) ->
            @dirty = false
            @currentCallback = cb

        getCharNative: (cb) ->
            @dirty = false
            @currentCallback = cb
            @native = true
