define [
    'common/game_common'
    'curses/drawing/curses_drawer'
    'curses/input/curses_input_source'
    'input/keymap'
    'util'
    'config'
], (GameCommon, CursesDrawer, CursesInputSource, Keymap, Util, Config) ->

    main = ->

        if Config.RANDOM_SEED?
            Math.seedrandom(Config.RANDOM_SEED)

        drawer = new CursesDrawer.CursesDrawer()
        Util.setDrawer(drawer)

        convert = Keymap.convertFromDvorak
        input = new CursesInputSource.CursesInputSource(drawer.gameWindow, convert)

        process.on('SIGINT', drawer.cleanup)
        process.on('exit', drawer.cleanup)

        drawer.gameWindow.top()
        game = new GameCommon.GameCommon(drawer, input)
        game.start()

    {
        main
    }
