require! './Direction.ls'
require! './Util.ls'

export const ControlTypes = {
    \DIRECTION
    \ACTION
    \MENU
}

class Control
    (name, type) ->
        @name = name
        @type = type
    toString: -> @name

class DirectionControl extends Control
    (name, direction) ->
        @name = name
        @type = ControlTypes.DIRECTION
        @direction = direction

export Controls = {}

for k, v of Direction.Directions
    Controls[k] = new DirectionControl k, v
