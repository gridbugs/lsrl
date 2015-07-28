define [\direction, \util], (direction, util) ->

    const ControlTypes = {
        \DIRECTION
        \ACTION
        \MENU
    }

    class Control
        (@name, @type) ~>
        toString: -> @name

    class DirectionControl
        (@name, @direction) ~>
            @type = ControlTypes.DIRECTION
        toString: -> @name

    Controls = {}

    for k, v of direction.Directions
        Controls[k] = DirectionControl k, v

    {
        Controls
        ControlTypes
    }
