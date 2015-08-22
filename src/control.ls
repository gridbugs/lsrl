define [
    \direction
    \types
    \util
], (Direction, Types, Util) ->

    class Control
        (@name, @type) ~>
        toString: -> @name

    class DirectionControl
        (@name, @direction) ~>
            @type = Types.Control.Direction
        toString: -> @name

    class AutoDirectionControl
        (@name, @direction) ~>
            @type = Types.Control.AutoDirection
        toString: -> @name

    Controls = {}

    for d in Direction.Directions
        name = Direction.getName(d)
        Controls[name] = DirectionControl name, d
        autoname = "Auto#{name}"
        Controls[autoname] = AutoDirectionControl autoname, d

    Controls.AutoExplore = Control 'AutoExplore', Types.Control.AutoExplore
    Controls.NavigateToCell = Control 'NavigateToCell', Types.Control.NavigateToCell
    Controls.Accept = Control 'Accept', Types.Control.Accept
    Controls.Escape = Control 'Escape', Types.Control.Escape
    Controls.Examine = Control 'Examine', Types.Control.Examine
    {
        Controls
    }
