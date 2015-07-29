define [
    \direction
    \trait
    \util
    \tile
], (Direction, Trait, Util, Tile) ->
    
    class Action
        cancel: ->
            @cancelled = true

        commitAndReschedule: ->
            @gameState.scheduleActionSource @commit!

    class BumpIntoWallAction extends Action
        (@character, @gameState) ->

            @traits = []

        commit: -> 20

    class MoveAction extends Action
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
            return 10
    {
        MoveAction
        BumpIntoWallAction
    }
