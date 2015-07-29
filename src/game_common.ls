define [\test], (test) ->

    class GameCommon
        (drawer, input_source) ->
            @gameDrawer = drawer
            @inputSource = input_source
            @gameState = @test!
            @drawer = drawer

        test: -> test.test @gameDrawer, @inputSource
        start: ->
            @gameState.scheduleActionSource @gameState.playerCharacter, 10
            @progressGameState!
            return
            @drawer.drawGameState @gameState
            action_source = @gameState.getCurrentActionSource!
            action_source.getAction @gameState, (action) ~>
                action.commit!
                @drawer.drawGameState @gameState
        gameTimeToMs: (t) -> t

        progressGameState: ->

            action_source = @gameState.getCurrentActionSource!
            @drawer.drawGameState @gameState
            action_source.getAction @gameState, (action) ~>
                @gameState.pushAction action
                @gameState.applyActionQueue!

                /* Progress the game state to the next action source */
                @gameState.progressSchedule!

                /* Get time until current action source (in game time) */
                time = @gameState.getCurrentTimeDelta!

                /* Process the next action after the time has passed */
                setTimeout (~>@progressGameState!), (@gameTimeToMs time)
    
    { GameCommon }
