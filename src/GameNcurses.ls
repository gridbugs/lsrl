require! ncurses
require! './GameCommon.ls'
require! './CursesDrawer.ls'

export run = ->
    ncurses.showCursor = false
    ncurses.echo = false
    stdscr = new ncurses.Window!

    cleanup = ->
        stdscr.close!
        ncurses.cleanup!

    process.on 'SIGINT' cleanup
    process.on 'exit'   cleanup

    gameCommon = new GameCommon.GameCommon (new CursesDrawer.CursesDrawer ncurses, stdscr)

    stdscr.on 'inputChar' (ch) ->
        gameCommon.processChar ch

    gameCommon.start!
