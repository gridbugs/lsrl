define [
    \action
], (Action) ->

    class SolidCell
        (@cell) ->

        match: (move_to_cell) -> move_to_cell.cell == @cell

        apply: (action) ->
            action.cancel!
            action.gameState.pushAction new Action.BumpIntoWallAction action.character, action.gameState

    {
        SolidCell
    }
