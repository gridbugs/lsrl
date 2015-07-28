define [
    \game_common
    \canvas_drawer
    \browser_input_source
    \keymap
    \util
], (game_common, canvas_drawer, browser_input_source, keymap, util) ->
    main = ->
        drawer = new canvas_drawer.CanvasDrawer $('#canvas')[0]
        input = new browser_input_source.BrowserInputSource keymap.Dvorak

        input.getControl (ctrl) ->
            console.debug "control", ctrl
            console.debug drawer
            console.debug input
    { main }
