define [
    \direction
    \util
], (Direction, Util) ->

    const ControlTypes = {
        \Direction
        \Action
        \Menu
        \AutoDirection
        \AutoExplore
        \NavigateToCell
        \Accept
        \Escape
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

    for d in Direction.Directions
        name = Direction.getName(d)
        Controls[name] = DirectionControl name, d
        autoname = "Auto#{name}"
        Controls[autoname] = AutoDirectionControl autoname, d

    Controls.AutoExplore = Control 'AutoExplore', ControlTypes.AutoExplore
    Controls.NavigateToCell = Control 'NavigateToCell', ControlTypes.NavigateToCell
    Controls.Accept = Control 'Accept', ControlTypes.Accept
    Controls.Escape = Control 'Escape', ControlTypes.Escape
    {
        Controls
        ControlTypes
    }
