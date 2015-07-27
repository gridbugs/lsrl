require! './GameCommon.ls': {GameCommon}
require! './CursesDrawer.ls': {CursesDrawer}
require! './CursesInputSource.ls': {CursesInputSource}

main = ->
    drawer = new CursesDrawer!
    input = new CursesInputSource drawer.game_window

    process.on 'SIGINT' drawer.cleanup
    process.on 'exit'   drawer.cleanup

    game = new GameCommon drawer, input
    game.start!

main() if require.main is module
