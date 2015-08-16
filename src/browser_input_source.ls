define [
    \util
], (util) ->

    class BrowserInputSource
        (keys) ->
            @keymap = keys
            @currentCallback = null
            @dirty = false

            $(window).keydown (e) ~>
                if @currentCallback?
                    tmp = @currentCallback
                    @currentCallback = null
                    key = String.fromCharCode e.keyCode
                    if e.shiftKey
                        ch = key.toUpperCase!
                    else
                        ch = key.toLowerCase!

                    tmp ch
                else
                    @dirty = true



        getControl: (cb) ->
            @getChar (c) ~>
                cb @keymap[c]

        getChar: (cb) ->
            @dirty = false
            @currentCallback = cb

    { BrowserInputSource }
