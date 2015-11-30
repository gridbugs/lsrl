define [
], ->
    class MouseEvent
        (@click, @down, @coord) ->

        getControl: ->
            return @ControlScheme.getMouseControl(this)

