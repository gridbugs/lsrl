define [
    'interface/input'
    'interface/keymap'
], (InputSource, Keymap) ->

    class CursesInputSource extends InputSource
        (window, @convert = Keymap.convertFromQwerty) ->
            super()

            window.on 'inputChar', (c) ~>
                if @currentCallback?
                    tmp = @currentCallback
                    @currentCallback = null
                    tmp(@convert(c))
                else
                    @dirty = true
