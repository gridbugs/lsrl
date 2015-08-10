define [
    \event
    \action
], (Event, Action) ->
    
    class Effectable
        forEachEffect: (f) ->
            for e in @effects
                f e
        

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
            if @fixture.strength > 0
                return [new Action.TryUnstick event.character, @fixture, game_state]
            else
                return [new Action.Unstick event.character, @fixture, game_state]

    
    {
        Effectable
        CellIsSolid
        CellIsSticky
    }

