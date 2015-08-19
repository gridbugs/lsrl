define [\util], (Util) ->

    class CursesInputSource
        (window, keys) ->
            @currentCallback = null
            @dirty = false

            window.on 'inputChar' (c) ~>
                if @currentCallback?
                    tmp = @currentCallback
                    @currentCallback = null
                    tmp c
                else
                    @dirty = true

            @keymap = []
            for k, v of keys
                code = Util.getCharCode k
                @keymap[code] = v

        getChar: (cb) ->
            @dirty = false
            @currentCallback = cb

        getControl: (cb) ~>
            @getChar (c) ~>
                code = Util.getCharCode c
                cb @keymap[code]

    { CursesInputSource }
