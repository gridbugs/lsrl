define [
    \game_common
    \canvas_drawer
    \browser_input_source
    \keymap
    \util
], (game_common, canvas_drawer, browser_input_source, keymap, util) ->
    main = ->
        console.log "main"
        console.debug $('#canvas')[0]
    { main }
