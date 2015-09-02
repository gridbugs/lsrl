define [
    'common/game_common'
    'canvas/drawing/canvas_drawer'
    'canvas/input/browser_input_source'
    'canvas/console/console'
    'input/keymap'
    'input/user_interface'
    'util'
    'config'
], (GameCommon, CanvasDrawer, BrowserInputSource, Console, Keymap, UserInterface, Util, Config) ->

    class Game extends GameCommon.GameCommon
        ->
            if window.location.hash == '#qwerty'
                convert = Keymap.convertFromQwerty
            else
                convert = Keymap.convertFromDvorak

            input = new BrowserInputSource.BrowserInputSource(convert)
            drawer = new CanvasDrawer.CanvasDrawer($('#canvas')[0], 120, 40, input)
            game_console = new Console.Console($('#log'))

            super(drawer, input, game_console)


    main = -> new Game().start()

    {
        Game
        main
    }
