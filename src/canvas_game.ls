define [
    \game_common
    \canvas_drawer
    \browser_input_source
    \keymap
    \util
], (game_common, canvas_drawer, browser_input_source, keymap, util) ->
    main = ->
        drawer = new canvas_drawer.CanvasDrawer $('#canvas')[0]
        console.debug drawer
    { main }
