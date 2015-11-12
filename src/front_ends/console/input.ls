define [
    'interface/input'
    'interface/keymap'
    'interface/user_interface'
], (BaseInput, Keymap, UserInterface) ->

    class ConsoleInput extends BaseInput
        (@convert = Keymap.convertFromQwerty) ->
            super()

        handleInputKey: (k) ->
            if @currentCallback?
                callback = @currentCallback
                @currentCallback = null
                callback(k)
            else
                @dirty = true
                @native = false

