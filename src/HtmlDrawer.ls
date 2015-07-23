export class HtmlDrawer
    (canvas) ->
        @canvas = canvas
        @ctx = @canvas.getContext '2d'

    drawGrid: (grid) ->
        @ctx.beginPath!
        @ctx.moveTo 10, 10
        @ctx.lineTo 20, 30
        @ctx.stroke!
