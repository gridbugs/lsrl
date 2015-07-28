define [
    \game_common
    \curses_drawer
    \curses_input_source
    \keymap
    \util
], (game_common, curses_drawer, curses_input_source, keymap, util) ->

    main = ->
        drawer = new curses_drawer.CursesDrawer!
        input = new curses_input_source.CursesInputSource drawer.game_window, keymap.Dvorak

        process.on 'SIGINT' drawer.cleanup
        process.on 'exit'   drawer.cleanup

        util.setPrintDrawer drawer

        drawer.game_window.top!
        game = new game_common.GameCommon drawer, input
        game.start!

    { main }
