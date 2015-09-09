define [
    'actions/event'
    'structures/direction'
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
            @toCell = @fromCell.neighbours[@direction]

            @events = [
                new Event.MoveFromCell @character, @fromCell
                new Event.MoveToCell @character, @toCell
            ]

            @cost = @fromCell.getMoveOutCost @direction

        commit: ->
            v = @character.position.add \
                Direction.Vectors[@direction]

            @character.getCell().character = void
            @character.position = v
            @character.getCell().character = @character.character

            if @character.getCell!.fixture.getName! == 'Web'
                return new CommitMetaData @cost, ["#{@character.getName()} gets stuck in a web."]

            return new CommitMetaData @cost, []

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

    class Null extends Action
        (@character, @gameState) ->
            @events = []
        commit: -> new CommitMetaData 1 []

    class Take extends Action
        (@character, @gameState, @groupId, @numItems) ->
            @events = []

        commit: ->
            items = @character.getCell().items.removeItemsByGroupId(@groupId, @numItems)
            char = @character.inventory.insertItems(items)

            return new CommitMetaData 2 ["#{@character.getName()} takes the #{items.first().getName()} (#{char})."]

    class Drop extends Action
        (@character, @gameState, @groupId, @numItems) ->
            @events = []

        commit: ->
            items = @character.inventory.removeItemsByGroupId(@groupId, @numItems)
            if items.length() == 0
                return new CommitMetaData 1 ["You ponder the meaning of life as you drop no items."]
            @character.getCell().items.insertItems(items)

            return new CommitMetaData 2 ["#{@character.getName()} drops #{@numItems} x #{items.first().getName()}."]

    class Open extends Action
        (@character, @cell, @gameState) ->
            @events = []

        commit: ->
            @cell.fixture.open()
            return new CommitMetaData 2 ["Door opened"]

    class Attack extends Action
        (@character, @direction, @gameState) ->
            @toCell = @fromCell.neighbours[@direction]


    {
        Null
        Move
        BumpIntoWall
        TryUnstick
        Unstick
        Take
        Drop
        Open
    }
