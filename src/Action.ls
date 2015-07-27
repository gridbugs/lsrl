require! './Direction.ls'

export class MoveAction
    (character, direction, grid) ->
        @character = character
        @direction = direction
        @grid = grid

    commit: ->
        @character.position = @character.position.add Direction.directionVectors[@direction]
