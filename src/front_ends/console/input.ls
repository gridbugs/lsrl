define [
    'interface/input'
    'interface/keymap'
], (BaseInput, Keymap) ->

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
