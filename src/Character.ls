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
            Util.print "control: #{control}"
            action = if control.type == ControlTypes.DIRECTION
                new Action.MoveAction this, control.direction, game_state

            cb action
/*
        @inputSource.getChar (ch) ~>
            process.stderr.write "#{ch}\n"
            process.stderr.write "#{ch.charCodeAt 0}\n"
            process.stderr.write "#{(ch.charCodeAt 0) == ncurses.keys.LEFT}\n"
            action = switch ch
            | 'd' => new Action.MoveAction this, Direction.WEST, game_state
            | 'h' => new Action.MoveAction this, Direction.SOUTH, game_state
            | 't' => new Action.MoveAction this, Direction.NORTH, game_state
            | 'n' => new Action.MoveAction this, Direction.EAST, game_state

            cb action
*/
