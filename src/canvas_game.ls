define [
    \game_common
    \canvas_drawer
    \browser_input_source
    \keymap
    \util
    \tile
], (game_common, canvas_drawer, browser_input_source, keymap, util, tile) ->
    main = ->
        drawer = new canvas_drawer.CanvasDrawer $('#canvas')[0], 120, 40
        input = new browser_input_source.BrowserInputSource keymap.Dvorak

        game = new game_common.GameCommon drawer, input
        game.start!

    { main }
