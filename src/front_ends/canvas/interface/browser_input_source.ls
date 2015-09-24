define [
    'interface/input_source'
    'interface/keymap'
], (InputSource, Keymap) ->

    class BrowserInputSource extends InputSource
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
