define [
    'interface/input'
    'interface/user_interface'
], (BaseInput, UserInterface) ->

    class ConsoleInput extends BaseInput
        ->
            super()

        handleInputKey: (k) ->
            if @currentCallback?
                callback = @currentCallback
                @currentCallback = null
                callback(k)
            else
                @dirty = true
                @native = false

