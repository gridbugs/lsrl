define [
], ->

    class Key
        (@char, @code, @shift, @control, @meta) ->

        getChar: ->
            if @shift
                return @char.toUpperCase()
            else
                return @char.toLowerCase()
        getIndex: ->
            return @code .|.    \
                (@shift .<<. Key.SHIFT_OFFSET) .|.  \
                (@control .<<. Key.CONTROL_OFFSET) .|.  \
                (@meta .<<. Key.META_OFFSET)
        getControl: ->
            return @ControlScheme.getControl(@getIndex())

    Key.SHIFT_OFFSET = 10
    Key.CONTROL_OFFSET = 11
    Key.META_OFFSET = 12

    Key.SHIFT = 1 .<<. Key.SHIFT_OFFSET
    Key.CONTROL = 1 .<<. Key.CONTROL_OFFSET
    Key.META = 1 .<<. Key.META_OFFSET

    Key.LEFT = 37
    Key.UP = 38
    Key.RIGHT = 39
    Key.DOWN = 40
    Key.ESCAPE = 27
    Key.ENTER = 13
    Key.PERIOD = 190
    Key.COMMA = 188

    return Key
