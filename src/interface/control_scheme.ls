define [
    'interface/control'
], (Control) ->

    class ControlScheme
        ->
            @array = []

        add: (object) ->

            for k, v of object
                @array[parseInt(k)] = Control[v]

        getControl: (index) ->
            control = @array[index]
            if control?
                return [control]
            else
                return void
