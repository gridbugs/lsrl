require! requirejs

process.stdout.write "."

require '../../../../lib/js-libs/seedrandom.js'

process.stdout.write "."

requirejs.config {
    baseUrl: '../../../'
    nodeRequire: require
}

process.stdout.write "."

requirejs [
    'front_ends/console/curses/game'
], (Game) ->
    process.stdout.write "done\n"
    Game.main()
