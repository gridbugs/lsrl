define [
    \input_source
    \keymap
    \util
], (InputSource, Keymap, Util) ->

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
