require! requirejs
require '../../../../lib/js-libs/seedrandom.js'
requirejs.config {
    baseUrl: '../../../'
    nodeRequire: require
}

requirejs [
    'front_ends/console/blessed/game'
], (Game) ->
    new Game().start()
