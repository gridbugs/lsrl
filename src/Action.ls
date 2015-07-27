require! './Direction.ls'

export class MoveAction
    (character, direction, game_state) ->
        @character = character
        @direction = direction
        @gameState = game_state

    commit: ->
        @character.position = @character.position.add Direction.directionVectors[@direction]
        @gameState.scheduleActionSource @character, 10
