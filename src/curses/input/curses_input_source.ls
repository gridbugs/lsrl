define [
    'input/input_source'
    'input/keymap'
], (InputSource, Keymap) ->

    class CursesInputSource extends InputSource.InputSource
        (window, @convert = Keymap.convertFromQwerty) ->
            super()

            window.on 'inputChar', (c) ~>
                if @currentCallback?
                    tmp = @currentCallback
                    @currentCallback = null
                    tmp(@convert(c))
                else
                    @dirty = true

    {
        CursesInputSource
    }
