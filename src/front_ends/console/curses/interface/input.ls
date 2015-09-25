define [
    'front_ends/console/input'
    'interface/keymap'
], (InputSource, Keymap) ->

    class CursesInputSource extends InputSource
        (window, convert = Keymap.convertFromQwerty) ->
            super(convert)

            window.on 'inputChar', (c) ~>
                @handleInputChar(c)
