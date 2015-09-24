requirejs.config {
    baseUrl: 'generated'
    paths: {
        lib: '../lib'
    }
}

requirejs [
    'front_ends/browser/canvas/canvas_game'
], (CanvasGame) ->
    CanvasGame.main()
