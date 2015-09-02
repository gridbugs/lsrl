define [
    'common/game_common'
    'curses/drawing/curses_drawer'
    'curses/input/curses_input_source'
    'curses/console/console'
    'input/keymap'
    'input/user_interface'
    'config'
], (GameCommon, CursesDrawer, CursesInputSource, Console, Keymap, UserInterface, Config) ->

    main = ->

        if Config.RANDOM_SEED?
            Math.seedrandom(Config.RANDOM_SEED)

        drawer = new CursesDrawer.CursesDrawer()

        convert = Keymap.convertFromDvorak
        input = new CursesInputSource.CursesInputSource(drawer.gameWindow, convert)
        game_console = new Console.Console(drawer.logWindow, drawer.gameWindow, drawer.ncurses)

        UserInterface.setUserInterface(drawer, input, game_console)

        process.on('SIGINT', drawer.cleanup)
        process.on('exit', drawer.cleanup)

        game = new GameCommon.GameCommon(drawer, input)
        game.start()

    {
        main
    }
