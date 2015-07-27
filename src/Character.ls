require! './Action.ls'
require! './Direction.ls'

export class PlayerCharacter
    (position, input_source) ->
        @position = position
        @inputSource = input_source

    getAction: (game_state, cb) ->
        process.stderr.write "calling getChar\n"
        @inputSource.getChar (ch) ~>
            process.stderr.write "#{ch}\n"
            if ch == 'd'
                cb new Action.MoveAction this, Direction.WEST, game_state
