define [
    'common/game_state'
    'interface/user_interface'
    'tests/test'
    'util'
    'assets/require'
    'assets/assets'
    'interface/key'
    'interface/mouse_event'
    'config'
    'debug'
], (GameState, UserInterface, Test, Util, Require, Assets, Key, MouseEvent, Config, Debug) ->

    class GameCommon
        (gameDrawer, gameController, gameConsole, gameHud) ->
            UserInterface.setUserInterface(gameDrawer, gameController, gameConsole, gameHud)
            Assets.Describer.English.install()

        seedRandom: ->
            if Config.RANDOM_SEED?
                seed = Config.RANDOM_SEED
            else
                seed = new Date().getTime()

            Util.printDebug "RNG Seed: #{seed}"
            Math.seedrandom(seed)

        setupPlayerCharacter: ->
            pc = @gameState.getPlayerCharacter()
            Assets.Describer.English.installPlayerCharacter(pc)
            Assets.TileSet.Default.installPlayerCharacter(pc)
            UserInterface.Global.gameController.setCharacter(pc)

        setupStartLevel: ->
            @gameState = new GameState()

            UserInterface.Global.gameController.setGameState(@gameState)

            @level = new Assets.Level[Config.START_LEVEL_NAME](@gameState)

            @gameState.setLevel(@level)

            @level.generate()

        setupDrawer: ->
            drawer = UserInterface.Global.gameDrawer

        start: ->
            @setupStartLevel()
            @setupPlayerCharacter()
            @setupDrawer()

            control_scheme = new Assets.ControlScheme[Config.Controls]()
            Key::ControlScheme = control_scheme
            MouseEvent::ControlScheme = control_scheme

            if Config.DRAW_MAP_ONLY
                return

            @gameLoop()

        gameTimeToMs: (t) ->
            if Config.FAST_ANIMATION
                return 0
            else
                return t * Config.ANIMATION_TIME

        gameLoop: ->
            @gameState.processObservers()
            @gameState.processContinuousEffects()
            UserInterface.drawCharacterKnowledge(@gameState.getPlayerCharacter(), @gameState)
            UserInterface.updateHud(@gameState.getPlayerCharacter())

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
            do
                action_source = @gameState.getCurrentActionSource()

                @gameState.progressSchedule()
            until action_source.isActive()

            UserInterface.updateHud(@gameState.getPlayerCharacter())
            action_source.getAction @gameState, (action) ~>
                @gameState.applyAction(action, action_source)

                /* Get time until current action source (in game time) */
                time = @gameState.getCurrentTimeDelta()

                callback(time, action_source == @gameState.getPlayerCharacter())

