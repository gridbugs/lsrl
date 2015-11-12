define [
    'interface/control'
], (Control) ->

    class ControlScheme
        (object) ->
            @array = []

            for k, v of object
                @array[parseInt(k)] = Control[v]

        getControl: (index) ->
            return @array[index]
