define [
    'front_ends/console/input'
    'interface/keymap'
], (BaseInput, Keymap) ->

    const ENTER_KEY = 13

    class Input extends BaseInput
        (@program, convert = Keymap.convertFromQwerty) ->
            super(convert)

            @expectingSecondEnterKey = false

            @program.on 'keypress', (c) ~>

                # Blessed sends the enter key twice when it is pressed once
                if @expectingSecondEnterKey and c.charCodeAt(0) == ENTER_KEY
                    @expectingSecondEnterKey = false
                    return

                if c.charCodeAt(0) == ENTER_KEY
                    @expectingSecondEnterKey = true

                @handleInputChar(c)

