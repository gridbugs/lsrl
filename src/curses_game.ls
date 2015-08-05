define [
    \game_common
    \curses_drawer
    \curses_input_source
    \keymap
    \util
    \cell
], (game_common, curses_drawer, curses_input_source, keymap, util, Cell) ->

    main = ->

        #Math.seedrandom 0

        drawer = new curses_drawer.CursesDrawer!
        input = new curses_input_source.CursesInputSource drawer.game_window, keymap.Dvorak

        process.on 'SIGINT' drawer.cleanup
        process.on 'exit'   drawer.cleanup

        drawer.game_window.top!
        game = new game_common.GameCommon drawer, input
        game.start!

    { main }
