define [
    \event
    \direction
], (Event, Direction) ->

    class Action
        commitAndReschedule: ->
            @gameState.scheduleActionSource @character, @commit!

    class Move extends Action
        (@character, @direction, @gameState) ->
            @fromCell = @gameState.grid.getCart @character.position
            @toCell = @fromCell.neighbours[@direction.index]

            @events = [
                new Event.MoveFromCell @character, @fromCell
                new Event.MoveToCell @character, @toCell
            ]

        commit: ->
            @character.position = @character.position.add \
                Direction.DirectionVectorsByIndex[@direction.index]
            return 10
        
    class BumpIntoWall extends Action
        (@character, @gameState) ->
            @events = []

        commit: -> 20

    {
        Move
        BumpIntoWall
    }
