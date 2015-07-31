define [
    \event
    \action
], (Event, Action) ->
    
    class CellIsSolid
        (@cell) ->

        match: (event) ->
            event.constructor == Event.MoveToCell and event.cell == @cell

        apply: (event, game_state) ->
            return {
                continue: false
                actions: [new Action.BumpIntoWall event.character, game_state]
            }

    {
        CellIsSolid
    }
