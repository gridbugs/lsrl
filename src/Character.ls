require! './Action.ls'
require! './Direction.ls'
require! './Util.ls'
require! './Controls.ls': {ControlTypes}
require! ncurses

export class PlayerCharacter
    (position, input_source) ->
        @position = position
        @inputSource = input_source

    getAction: (game_state, cb) ->
        @inputSource.getControl (control) ~>
            action = if control.type == ControlTypes.DIRECTION
                new Action.MoveAction this, control.direction, game_state

            cb action
