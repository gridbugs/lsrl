define [
    \event
    \direction
], (Event, Direction) ->

    class CommitMetaData
        (@time, @descriptions = []) ->

    class Action
        commitAndReschedule: ->
            data = @commit!
            @gameState.scheduleActionSource @character, data.time
            return data.descriptions

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
            
            if @character.getCell!.fixture.constructor.name == 'Web'
                return new CommitMetaData 10 ["#{@character.getName()} gets stuck in a web."]

            return new CommitMetaData 10 []
        
    class BumpIntoWall extends Action
        (@character, @gameState) ->
            @events = []

        commit: -> new CommitMetaData 5 ["#{@character.getName()} bumps into a wall."]

    class TryUnstick extends Action
        (@character, @fixture, @gameState) ->
            @events = []

        commit: ->
            @fixture.tryUnstick!
            return new CommitMetaData 5 ["#{@character.getName()} struggles in the web."]

    class Unstick extends Action
        (@character, @fixture, @gameState) ->
            @events = []

        commit: ->
            @fixture.unstick!
            return new CommitMetaData 5 ["#{@character.getName()} breaks free from the web."]

    {
        Move
        BumpIntoWall
        TryUnstick
        Unstick
    }
