requirejs.config {
    baseUrl: 'generated'
    paths: {
        lib: '../lib'
    }
}

requirejs [
    'front_ends/browser/canvas/game'
], (CanvasGame) ->
    CanvasGame.main()
