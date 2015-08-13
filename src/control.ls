define [\direction, \util], (direction, util) ->

    const ControlTypes = {
        \Direction
        \Action
        \Menu
        \AutoDirection
        \AutoExplore
    }

    class Control
        (@name, @type) ~>
        toString: -> @name

    class DirectionControl
        (@name, @direction) ~>
            @type = ControlTypes.Direction
        toString: -> @name

    class AutoDirectionControl
        (@name, @direction) ~>
            @type = ControlTypes.AutoDirection
        toString: -> @name

    Controls = {}

    for k, v of direction.Directions
        Controls[k] = DirectionControl k, v

    for k, v of direction.Directions
        name = "Auto#{k}"
        Controls[name] = AutoDirectionControl name, v

    Controls.AutoExplore = Control 'AutoExplore', ControlTypes.AutoExplore

    {
        Controls
        ControlTypes
    }
