define [
    'common/game_common'
    'canvas/drawing/canvas_drawer'
    'canvas/input/browser_input_source'
    'input/keymap'
    'util'
], (GameCommon, CanvasDrawer, BrowserInputSource, Keymap, Util) ->
    main = ->

        #Math.seedrandom 0

        drawer = new CanvasDrawer.CanvasDrawer $('#canvas')[0], 120, 40
        Util.setDrawer(drawer)

        if window.location.hash == '#qwerty'
            convert = Keymap.convertFromQwerty
        else
            convert = Keymap.convertFromDvorak

        input = new BrowserInputSource.BrowserInputSource(convert)

        game = new GameCommon.GameCommon(drawer, input)
        game.start()

    {
        main
    }
