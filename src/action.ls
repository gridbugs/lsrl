define [\direction], (direction) ->

    class NullAction
        (@character, @gameState) ->
        commit: ->
            @gameState.scheduleActionSource @character, 0

    class MoveAction
        (@character, @direction, @gameState) ->

        commit: ->
            @character.position = @character.position.add \
                direction.DirectionVectorsByIndex[@direction.index]
            @gameState.scheduleActionSource @character, 10

    {
        MoveAction
        NullAction
    }
