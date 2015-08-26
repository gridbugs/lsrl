require! requirejs
require '../../lib/js-libs/seedrandom.js'
requirejs.config {
    baseUrl: '../'
    nodeRequire: require
}

requirejs [
    'curses/curses_game'
], (CursesGame) ->
    CursesGame.main()
