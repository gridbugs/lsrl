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

        clear: ->
            @program.move(@left + 1, @top + 1)
            for i from 0 til @height - 2
                @program.write(' ' * (@width - 2) + '\n')
                @program.setx(@left + 1)

    {
        drawBox

        Boxable
    }
