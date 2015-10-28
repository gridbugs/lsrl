define [
], ->

    class Controller
        ->
            @active = true

        deactivate: ->
            @active = false

        isActive: ->
            return @active
