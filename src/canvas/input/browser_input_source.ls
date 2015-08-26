define [
    'input/input_source'
    'input/keymap'
], (InputSource, Keymap) ->

    class BrowserInputSource extends InputSource.InputSource
        (@convert = Keymap.convertFromQwerty) ->
            super()

            $(window).keydown (e) ~>
                if @currentCallback?
                    tmp = @currentCallback
                    @currentCallback = null
                    key = String.fromCharCode e.keyCode
                    if e.shiftKey
                        ch = key.toUpperCase()
                    else
                        ch = key.toLowerCase()

                    tmp(@convert(ch))
                else
                    @dirty = true

    {
        BrowserInputSource
    }
