requirejs.config {
    baseUrl: 'generated'
    paths: {
        lib: '../lib'
    }
}

requirejs [
    'canvas/canvas_game'
], (CanvasGame) ->
    CanvasGame.main()
