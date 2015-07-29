define [
    \direction
    \trait
    \util
], (Direction, Trait, Util) ->

    class MoveAction
        (@character, @direction, @gameState) ->

            from_cell = @gameState.grid.getCart @character.position
            to_cell = from_cell.neighbours[@direction.index]
            
            @traits = [
                Trait.MoveToCell @character, to_cell
                Trait.MoveFromCell @character, from_cell
            ]

        commit: ->
            @character.position = @character.position.add \
                Direction.DirectionVectorsByIndex[@direction.index]
            @gameState.scheduleActionSource @character, 10

    {
        MoveAction
    }
