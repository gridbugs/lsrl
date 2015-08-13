define [
    \util
], (util) ->

    class BrowserInputSource
        (keys) ->
            @keymap = keys
            @currentCallback = (->)

            $(window).keydown (e) ~>
                tmp = @currentCallback
                @currentCallback = (->)
                key = String.fromCharCode e.keyCode
                if e.shiftKey
                    ch = key.toUpperCase!
                else
                    ch = key.toLowerCase!

                tmp ch


        getControl: (cb) ->
            @getChar (c) ~>
                cb @keymap[c]

        getChar: (cb) ->
            @currentCallback = cb

    { BrowserInputSource }
