require! './GameCommon.ls': {GameCommon}
require! './CursesDrawer.ls': {CursesDrawer}
require! './CursesInputSource.ls': {CursesInputSource}
require! './Keymaps.ls'
require! './Util.ls'
require! ncurses

main = ->
    drawer = new CursesDrawer!
    input = new CursesInputSource drawer.game_window, Keymaps.Dvorak

    process.on 'SIGINT' drawer.cleanup
    process.on 'exit'   drawer.cleanup

    Util.setPrintDrawer drawer

    game = new GameCommon drawer, input
    game.start!

main() if require.main is module
