define [
    \event
    \action
], (Event, Action) ->
    
    class CellIsSolid
        (@cell) ->

        match: (event) ->
            event.constructor == Event.MoveToCell and event.cell == @cell

        cancells: (event) -> true

        getActions: (event, game_state) ->
            [new Action.BumpIntoWall event.character, game_state]

    {
        CellIsSolid
    }
