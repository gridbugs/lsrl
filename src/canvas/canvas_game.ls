define [
    'common/game_common'
    'canvas/drawing/canvas_drawer'
    'canvas/input/browser_input_source'
    'canvas/console/console'
    'input/keymap'
    'input/user_interface'
    'config'
], (GameCommon, CanvasDrawer, BrowserInputSource, Console, Keymap, UserInterface, Config) ->
    main = ->

        if Config.RANDOM_SEED?
            Math.seedrandom(Config.RANDOM_SEED)

        if window.location.hash == '#qwerty'
            convert = Keymap.convertFromQwerty
        else
            convert = Keymap.convertFromDvorak


        input = new BrowserInputSource.BrowserInputSource(convert)
        drawer = new CanvasDrawer.CanvasDrawer($('#canvas')[0], 120, 40, input)
        game_console = new Console.Console($('#log'))

        UserInterface.setUserInterface(drawer, input, game_console)

        game = new GameCommon.GameCommon(drawer, input)
        game.start()

    {
        main
    }
