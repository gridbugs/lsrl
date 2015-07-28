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

                ch = (String.fromCharCode e.keyCode).toLowerCase!
                console.log ch
                tmp @keymap[ch]


        getControl: (cb) ->
            @currentControlCallback = cb

    { BrowserInputSource }
