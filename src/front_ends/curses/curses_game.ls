define [
    'common/game_common'
    'front_ends/curses/drawing/curses_drawer'
    'front_ends/curses/interface/curses_input_source'
    'front_ends/curses/interface/console'
    'front_ends/curses/interface/hud'
    'interface/keymap'
    'interface/user_interface'
    'util'
    'config'
], (GameCommon, CursesDrawer, CursesInputSource, Console, Hud, Keymap, UserInterface, Util, Config) ->

    class Game extends GameCommon
        ->
            drawer = new CursesDrawer()

            convert = Keymap.convertFromDvorak
            input = new CursesInputSource(drawer.gameWindow, convert)
            game_console = new Console(drawer.logWindow, drawer.gameWindow, drawer.ncurses)
            hud = new Hud(drawer.hudWindow)

            process.on('SIGINT', drawer.cleanup)
            process.on('exit', drawer.cleanup)

            super(drawer, input, game_console, hud)

    main = -> new Game().start()

    {
        Game
        main
    }
