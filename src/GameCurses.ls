require! './GameCommon.ls': {GameCommon}
require! './CursesDrawer.ls': {CursesDrawer}
require! './CursesInputSource.ls': {CursesInputSource}

main = ->
    drawer = new CursesDrawer!
    input = new CursesInputSource drawer.getGameWindow!

    process.on 'SIGINT' drawer.cleanup
    process.on 'exit'   drawer.cleanup

    game = new GameCommon drawer, input
    game.test drawer

main() if require.main is module
