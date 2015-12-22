define [
    'structures/direction'
    'types'
    'util'
], (Direction, Types, Util) ->

    class BasicControl
        (@name, @type) ->
        toString: -> @name

    class DirectionControl
        (@name, @direction) ->
            @type = Types.Control.Direction
        toString: -> @name

    class AutoDirectionControl
        (@name, @direction) ->
            @type = Types.Control.AutoDirection
        toString: -> @name

    Control = {}

    for d in Direction.Directions
        name = Direction.getName(d)
        Control[name] = new DirectionControl(name, d)
        autoname = "Auto#{name}"
        Control[autoname] = new AutoDirectionControl(autoname, d)

    createBasicControl = (name) ->
        Control[name] = new BasicControl(name, Types.Control[name])

    # Basic Controls
    [
        'AutoExplore'
        'NavigateToCell'
        'Accept'
        'Escape'
        'Examine'
        'Get'
        'Drop'
        'Inventory'
        'Test'
        'Wait'
        'Descend'
        'Ascend'
        'Equip'
        'SwapWeapons'
    ].map(createBasicControl)

    return Control
