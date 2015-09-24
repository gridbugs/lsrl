define [
    'common/game'
    'front_ends/browser/canvas/drawing/drawer'
    'front_ends/browser/canvas/interface/input'
    'front_ends/browser/canvas/interface/console'
    'front_ends/browser/canvas/interface/hud'
    'interface/keymap'
    'interface/user_interface'
    'util'
    'config'
], (GameCommon, CanvasDrawer, BrowserInputSource, Console, Hud, Keymap, UserInterface, Util, Config) ->

    class Game extends GameCommon
        ->

            @seedRandom()

            if window.location.hash == '#qwerty'
                convert = Keymap.convertFromQwerty
            else
                convert = Keymap.convertFromDvorak

            input = new BrowserInputSource(convert)
            drawer = new CanvasDrawer($('#canvas')[0], 120, 40, input)
            game_console = new Console($('#log'))
            hud = new Hud($('#hud'))

            super(drawer, input, game_console, hud)


    main = -> new Game().start()

    {
        Game
        main
    }
