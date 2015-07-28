requirejs.config {
    paths: {
        lib: '../lib'
    }
}

requirejs [
    \canvas_game
], (canvas_game) ->
    canvas_game.main!
