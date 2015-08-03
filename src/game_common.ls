define [
    \test
    \util
], (Test, Util) ->

    class GameCommon
        (drawer, input_source) ->
            @gameDrawer = drawer
            @inputSource = input_source
            @gameState = @test!
            @drawer = drawer

        test: -> Test.test @gameDrawer, @inputSource
        start: ->

            @gameState.scheduleActionSource @gameState.playerCharacter, 10
            @progressGameState!
        
        gameTimeToMs: (t) -> t

        progressGameState: ->

            action_source = @gameState.getCurrentActionSource!
            @gameState.playerCharacter.observe @gameState
            @drawer.drawCharacterKnowledge @gameState.playerCharacter
            action_source.getAction @gameState, (action) ~>
                descriptions = @gameState.applyAction action
                for desc in descriptions
                    @drawer.print desc

                /* Progress the game state to the next action source */
                @gameState.progressSchedule!

                /* Get time until current action source (in game time) */
                time = @gameState.getCurrentTimeDelta!

                /* Process the next action after the time has passed */
                setTimeout (~>@progressGameState!), (@gameTimeToMs time)
    
    { GameCommon }
