requirejs.config {
    paths: {
        lib: '../lib'
    }
}

requirejs [
    \canvas_game
], (CanvasGame) ->
    CanvasGame.main()
