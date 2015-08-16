define [\util], (Util) ->

    class CursesInputSource
        (window, keys) ->
            @currentCallback = (->)
            @window = window
            window.on 'inputChar' (c) ~>
                Util.printDrawer c
                tmp = @currentCallback
                @currentCallback = (->)
                tmp c

            @keymap = []
            for k, v of keys
                code = Util.getCharCode k
                @keymap[code] = v

        getChar: (cb) ->
            @currentCallback = cb

        getControl: (cb) ->
            @getChar (c) ~>
                code = Util.getCharCode c
                cb @keymap[code]

    { CursesInputSource }
