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
            @toCell = @fromCell.neighbours[@direction]

            @events = [
                new Event.MoveFromCell @character, @fromCell
                new Event.MoveToCell @character, @toCell
            ]

            @cost = @fromCell.getMoveOutCost @direction


        commit: ->
            @character.position = @character.position.add \
                Direction.Vectors[@direction]

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
        (@character, @gameState, @item) ->
            @events = []

        commit: ->
            @item.collection.removeItem(@item)
            char = @character.addItemToInventory(@item)
            return new CommitMetaData 2 ["#{@character.getName()} takes the #{@item.getName()}(#{char})."]

    class Drop extends Action
        (@character, @gameState, @item) ->
            @events = []

        commit: ->
            removed_item = @character.removeItemFromInventory(@item)
            @character.getCell().addItem(removed_item)
            return new CommitMetaData 2 ["#{@character.getName()} drops the #{removed_item.getName()}."]


    {
        Null
        Move
        BumpIntoWall
        TryUnstick
        Unstick
        Take
        Drop
    }
