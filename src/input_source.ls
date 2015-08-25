define [
    \keymap
], (Keymap) ->

    class InputSource
        ->
            @currentCallback = void

        getControl: (cb) ~>
            @getChar (c) ~>
                cb(Keymap.Controls[c])

        getChar: (cb) ~>
            @dirty = false
            @currentCallback = cb

    {
        InputSource
    }
