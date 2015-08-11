define [
    \util
], (util) ->

    class BrowserInputSource
        (keys) ->
            @keymap = keys
            @currentControlCallback = (->)
            $(window).keydown (e) ~>
                tmp = @currentControlCallback
                @currentControlCallback = (->)
                key = String.fromCharCode e.keyCode
                if e.shiftKey
                    ch = key.toUpperCase!
                else
                    ch = key.toLowerCase!

                tmp @keymap[ch]


        getControl: (cb) ->
            @currentControlCallback = cb

    { BrowserInputSource }
