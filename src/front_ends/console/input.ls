define [
    'interface/input'
    'interface/keymap'
    'interface/user_interface'
], (BaseInput, Keymap, UserInterface) ->

    class ConsoleInput extends BaseInput
        (@convert = Keymap.convertFromQwerty) ->
            super()

        handleInputChar: (c) ->
            if @currentCallback?
                tmp = @currentCallback
                @currentCallback = null
                tmp(@convert(c))
            else
                @dirty = true
