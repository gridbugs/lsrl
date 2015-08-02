define [
    \event
    \action
], (Event, Action) ->
    
    class Effectable
        forEachEffect: (f) ->
            @effects.forEach f
        

    class CellIsSolid
        (@cell) ->

        match: (event) ->
            event.constructor == Event.MoveToCell and event.cell == @cell

        cancells: (event) -> true

        getActions: (event, game_state) ->
            [new Action.BumpIntoWall event.character, game_state]

    class CellIsSticky
        (@cell, @fixture) ->
        
        match: (event) ->
            event.constructor == Event.MoveFromCell and event.cell == @cell

        cancells: (event) -> true
        
        getActions: (event, game_state) ->
            [new Action.TryUnstick event.character, @fixture, game_state]
    
    {
        Effectable
        CellIsSolid
        CellIsSticky
    }

