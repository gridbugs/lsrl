define [
    'common/game'
    'front_ends/console/curses/drawing/drawer'
    'front_ends/console/curses/drawing/tile'
    'front_ends/console/curses/interface/input'
    'front_ends/console/curses/interface/console'
    'front_ends/console/curses/interface/hud'
    'interface/keymap'
    'interface/user_interface'
    'util'
    'config'
], (GameCommon, CursesDrawer, CursesTile, CursesInputSource, Console, Hud, Keymap, UserInterface, Util, Config) ->

    class Game extends GameCommon
        ->
            @seedRandom()

            drawer = new CursesDrawer(CursesTile.TileStyles)

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
