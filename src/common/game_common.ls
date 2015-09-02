define [
    'input/user_interface'
    'tests/test'
    'util'
    'config'
    'debug'
], (UserInterface, Test, Util, Config, Debug) ->

    class GameCommon
        (gameDrawer, gameController, gameConsole) ->
            
            UserInterface.setUserInterface(gameDrawer, gameController, gameConsole)
            
            if Config.RANDOM_SEED?
                seed = Config.RANDOM_SEED
            else
                seed = new Date().getTime()

            Util.printDebug "RNG Seed: #{seed}"
            Math.seedrandom(seed)

        test: -> Test.test()

        start: ->
            @gameState = @test()

            if Config.DRAW_MAP_ONLY
                return

            @gameState.scheduleActionSource(@gameState.playerCharacter, 10)
            @progressGameState()

        gameTimeToMs: (t) ->
            if Config.FAST_ANIMATION
                return 0
            else
                return t * 0.5

        progressGameState: ->
            action_source = @gameState.getCurrentActionSource()

            @gameState.progressSchedule()

            @gameState.playerCharacter.observe(@gameState)
            UserInterface.drawCharacterKnowledge(@gameState.playerCharacter, @gameState)

            action_source.getAction @gameState, (action) ~>
                descriptions = @gameState.applyAction action
                for desc in descriptions
                    UserInterface.printLine desc


                /* Get time until current action source (in game time) */
                time = @gameState.getCurrentTimeDelta!

                /* Process the next action after the time has passed */
                setTimeout (~>@progressGameState!), (@gameTimeToMs time)

    {
        GameCommon
    }