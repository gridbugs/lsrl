define [
    'front_ends/console/input'
    'interface/keymap'
], (BaseInput, Keymap) ->

    class Input extends BaseInput
        (@program, convert = Keymap.convertFromQwerty) ->
            super(convert)

            @program.on 'keypress', (c) ~>
                @handleInputChar(c)
