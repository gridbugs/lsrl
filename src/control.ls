define [\direction, \util], (direction, util) ->

    const ControlTypes = {
        \DIRECTION
        \ACTION
        \MENU
        \AUTO_DIRECTION
    }

    class Control
        (@name, @type) ~>
        toString: -> @name

    class DirectionControl
        (@name, @direction) ~>
            @type = ControlTypes.DIRECTION
        toString: -> @name

    class AutoDirectionControl
        (@name, @direction) ~>
            @type = ControlTypes.AUTO_DIRECTION
        toString: -> @name

    Controls = {}

    for k, v of direction.Directions
        Controls[k] = DirectionControl k, v

    for k, v of direction.Directions
        name = "AUTO_#{k}"
        Controls[name] = AutoDirectionControl name, v

    {
        Controls
        ControlTypes
    }
