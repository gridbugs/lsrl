define [
    \action
    \trait
], (Action, Trait) ->

    class SolidCellEffect
        (@cell) ->

        match: (trait) ->
            trait.constructor == Trait.MoveToCell and trait.cell == @cell

        apply: (action) ->
            action.cancel!
            [new Action.BumpIntoWallAction action.character, action.gameState]


    {
        SolidCellEffect
    }
