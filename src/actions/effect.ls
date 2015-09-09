define [
    'actions/event'
    'actions/action'
    'types'
], (Event, Action, Types) ->

    class Effectable
        forEachEffect: (f) ->
            for e in @effects
                f e

    class ReactiveEffect
        (@eventType) ->

    class Solid extends ReactiveEffect
        ->
            super(Types.Event.MoveToCell)

        apply: (status) ->
            status.fail('attempted to enter solid cell')
            status.gameState.actionQueue.push(
                new Action.BumpIntoWall(status.action.character)
            )

    class CellIsSolid
        (@cell) ->

        match: (event) ->
            event.type == Types.Event.MoveToCell and event.cell == @cell

        cancells: (event) -> true

        getActions: (event, game_state) ->
            [new Action.BumpIntoWall(event.character, game_state)]

    class CellIsOpenable
        (@cell) ->

        match: (event) ->
            event.type == Types.Event.MoveToCell and event.cell == @cell

        cancells: (event) -> not @cell.fixture.isOpen()

        getActions: (event, game_state) ->
            if @cell.fixture.isOpen()
                []
            else
                [new Action.Open(event.character, @cell, game_state)]

    class CellIsSticky
        (@cell, @fixture) ->

        match: (event) ->
            event.type == Types.Event.MoveFromCell and event.cell == @cell

        cancells: (event) -> true

        getActions: (event, game_state) ->
            if @fixture.strength > 0
                return [new Action.TryUnstick(event.character, @fixture, game_state)]
            else
                return [new Action.Unstick(event.character, @fixture, game_state)]


    {
        Effectable
        CellIsSolid
        CellIsSticky
        CellIsOpenable
        Solid
    }

