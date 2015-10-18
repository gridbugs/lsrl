define [
    'common/game'
    'front_ends/browser/canvas/drawing/drawer'
    'front_ends/browser/canvas/drawing/tile'
    'front_ends/browser/canvas/interface/input'
    'front_ends/browser/canvas/interface/console'
    'front_ends/browser/canvas/interface/hud'
    'interface/keymap'
    'tile_schemes/default'
    'util'
    'config'
], (GameCommon, CanvasDrawer, Tile, BrowserInputSource, Console, Hud, Keymap, DefaultTileScheme, Util, Config) ->

    class Game extends GameCommon
        ->

            @seedRandom()

            if window.location.hash == '#qwerty'
                convert = Keymap.convertFromQwerty
            else
                convert = Keymap.convertFromDvorak

            input = new BrowserInputSource(convert)
            drawer = new CanvasDrawer($('#canvas')[0], new DefaultTileScheme(Tile.TileSet), 80, 30, input)
            game_console = new Console($('#log'))
            hud = new Hud($('#hud'))

            super(drawer, input, game_console, hud)


    main = -> new Game().start()

    {
        Game
        main
    }
