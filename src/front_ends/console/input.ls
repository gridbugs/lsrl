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
                if @native
                    @native = false
                    tmp(c)
                else
                    tmp(@convert(c))
            else
                @dirty = true
                @native = false

