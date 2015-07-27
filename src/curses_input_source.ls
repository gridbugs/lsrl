define [\util], (util) ->

    class CursesInputSource
        (window, keys) ->
            @currentCallback = (->)
            @window = window
            window.on 'inputChar' (c) ~>
                tmp = @currentCallback
                @currentCallback = (->)
                tmp c

            @keymap = []
            for k, v of keys
                code = util.getCharCode k
                @keymap[code] = v

        getChar: (cb) ->
            @window.top!
            @currentCallback = cb

        getControl: (cb) ->
            @getChar (c) ~>
                code = util.getCharCode c
                cb @keymap[code]

    { CursesInputSource }
