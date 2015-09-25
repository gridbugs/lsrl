define [
    'front_ends/console/box'
], (Box) ->
    
    drawBox = (program, border, left, top, width, height) ->
        Box.forEachIndexAtBorder width, height, (x, y, direction) ->
            program.move(left + x, top + y)
            program.write(border[direction])

    Boxable =
        drawBox: ->
            drawBox(@program, @border, @left, @top, @width, @height)


    {
        drawBox

        Boxable
    }
