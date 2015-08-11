define [
    \test
    \util
    \debug
], (Test, Util, Debug) ->

    class GameCommon
        (drawer, input_source) ->
            @gameDrawer = drawer
            @inputSource = input_source
            @gameState = @test!
            @drawer = drawer

        test: -> Test.test @gameDrawer, @inputSource
        start: ->
            if Debug.DRAW_MAP_ONLY
                return

            @gameState.scheduleActionSource @gameState.playerCharacter, 10
            @progressGameState!

        gameTimeToMs: (t) -> t * 0.5

        progressGameState: ->
            action_source = @gameState.getCurrentActionSource!

            @gameState.progressSchedule!

            @gameState.playerCharacter.observe @gameState
            @drawer.drawCharacterKnowledge @gameState.playerCharacter, @gameState


            action_source.getAction @gameState, (action) ~>
                descriptions = @gameState.applyAction action
                for desc in descriptions
                    @drawer.print desc


                /* Get time until current action source (in game time) */
                time = @gameState.getCurrentTimeDelta!

                /* Process the next action after the time has passed */
                setTimeout (~>@progressGameState!), (@gameTimeToMs time)

    { GameCommon }
