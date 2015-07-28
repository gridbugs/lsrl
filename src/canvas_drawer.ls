define [
    \tile
    \canvas_tile
], (tile, canvas_tile) ->

    class CanvasDrawer
        (@canvas) ->
            @ctx = @canvas.getContext '2d'

    { CanvasDrawer }
