requirejs.config {
    baseUrl: 'generated'
    paths: {
        lib: '../lib'
    }
}

requirejs [
    'front_ends/canvas/canvas_game'
], (CanvasGame) ->
    CanvasGame.main()
