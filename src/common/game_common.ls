define [
    'input/user_interface'
    'tests/test'
    'util'
    'config'
    'debug'
], (UserInterface, Test, Util, Config, Debug) ->

    class GameCommon
        (gameDrawer, gameController, gameConsole, gameHud) ->
            UserInterface.setUserInterface(gameDrawer, gameController, gameConsole, gameHud)

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

            @gameLoop()

        gameTimeToMs: (t) ->
            if Config.FAST_ANIMATION
                return 0
            else
                return t * 0.01
        gameLoop: ->

            @gameState.processContinuousEffects()
            @gameState.processObservers()
            UserInterface.drawCharacterKnowledge(@gameState.playerCharacter, @gameState)
            UserInterface.updateHud(@gameState.playerCharacter.character)

            looping = true
            done = false
            while not done
                done = true
                @progressGameState (game_time, is_player_character) ~>
                    real_time_ms = @gameTimeToMs(game_time)
                    if looping and real_time_ms == 0 and not is_player_character
                        done := false
                        return

                    setTimeout(@~gameLoop, real_time_ms)

            looping = false

        progressGameState: (callback) ->
            action_source = @gameState.getCurrentActionSource()

            @gameState.progressSchedule()

            action_source.getAction @gameState, (action) ~>

                @gameState.applyAction(action)

                /* Get time until current action source (in game time) */
                time = @gameState.getCurrentTimeDelta()

                callback(time, action_source == @gameState.playerCharacter)

    {
        GameCommon
    }
