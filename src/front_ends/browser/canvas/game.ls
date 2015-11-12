define [
    'common/game'
    'front_ends/browser/canvas/drawing/drawer'
    'front_ends/browser/canvas/drawing/tile'
    'front_ends/browser/canvas/interface/input'
    'front_ends/browser/canvas/interface/console'
    'front_ends/browser/canvas/interface/hud'
    'tile_schemes/default'
    'util'
    'config'
], (GameCommon, CanvasDrawer, Tile, BrowserInputSource, Console, Hud, DefaultTileScheme, Util, Config) ->

    class Game extends GameCommon
        ->

            @seedRandom()

            input = new BrowserInputSource()
            drawer = new CanvasDrawer($('#canvas')[0], new DefaultTileScheme(Tile.TileSet), 80, 30, input)
            game_console = new Console($('#log'))
            hud = new Hud($('#hud'))

            super(drawer, input, game_console, hud)


    main = ->

        pairs = window.location.search.split("?").filter (.length)
        for p in pairs
            [key, value] = p.split("=")
            Config[key] = value

        new Game().start()

    {
        Game
        main
    }
