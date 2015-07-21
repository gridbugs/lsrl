require! ncurses
require! './GameCommon.ls'
require! './CursesDrawer.ls'
require! './CursesInputSource.ls'

export run = ->
    ncurses.showCursor = false
    ncurses.echo = false
    stdscr = new ncurses.Window!
    win0 = new ncurses.Window(40, 120, 0, 0)
    win1 = new ncurses.Window(47, 40, 0, 122)
    win2 = new ncurses.Window(6, 120, 41, 0)

    cleanup = ->
        win0.close!
        stdscr.close!
        ncurses.cleanup!

    process.on 'SIGINT' cleanup
    process.on 'exit'   cleanup

    gameCommon = new GameCommon.GameCommon(
        (new CursesDrawer.CursesDrawer ncurses, win0, win1, win2),
        (new CursesInputSource.CursesInputSource  win0)
    )

    gameCommon.start!
