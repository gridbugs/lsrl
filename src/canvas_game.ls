define [
    \game_common
    \canvas_drawer
    \browser_input_source
    \keymap
    \util
    \tile
], (game_common, canvas_drawer, browser_input_source, keymap, util, tile) ->
    main = ->

        Math.seedrandom 0

        drawer = new canvas_drawer.CanvasDrawer $('#canvas')[0], 120, 40
        util.setDrawer drawer

        if window.location.hash == '#qwerty'
            keys = keymap.Qwerty
        else
            keys = keymap.Dvorak

        input = new browser_input_source.BrowserInputSource keys

        game = new game_common.GameCommon drawer, input
        game.start!

    { main }
