define [\direction, \util], (direction, util) ->

    const ControlTypes = {
        \DIRECTION
        \ACTION
        \MENU
    }

    class Control
        (@name, @type) ~>

    class DirectionControl
        (@name, @direction) ~>
            @type = ControlTypes.DIRECTION

    Controls = {}

    for k, v of direction.Directions
        Controls[k] = DirectionControl k, v

    {
        Controls
        ControlTypes
    }
