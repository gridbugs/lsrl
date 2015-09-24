require! requirejs
require '../../../../lib/js-libs/seedrandom.js'
requirejs.config {
    baseUrl: '../../../'
    nodeRequire: require
}

requirejs [
    'front_ends/console/curses/game'
], (Game) ->
    Game.main()
