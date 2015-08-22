define [
    \game_common
    \canvas_drawer
    \browser_input_source
    \keymap
    \util
    \tile
], (GameCommon, CanvasDrawer, BrowserInputSource, Keymap, Util, Tile) ->
    main = ->

        #Math.seedrandom 0

        drawer = new CanvasDrawer.CanvasDrawer $('#canvas')[0], 120, 40
        Util.setDrawer drawer

        if window.location.hash == '#qwerty'
            keys = Keymap.Qwerty
        else
            keys = Keymap.Dvorak

        input = new BrowserInputSource.BrowserInputSource keys

        game = new GameCommon.GameCommon drawer, input
        game.start!

    { main }
