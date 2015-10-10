define [
    'structures/grid_window'
], (GridWindow) ->
            
    const PADDING = 8

    class Drawer
        (width, height) ->
            @window = new GridWindow(0, 0, width, height)

        adjustWindow: (character, grid) ->

            pos = character.character.position

            if pos.y > @window.offsetY + @window.height - PADDING
                @window.setOffsetY(pos.y - @window.height + PADDING)
            else if pos.y < @window.offsetY + PADDING
                @window.setOffsetY(pos.y - PADDING)

            if pos.x > @window.offsetX + @window.width - PADDING
                @window.setOffsetX(pos.x - @window.width + PADDING)
            else if pos.x < @window.offsetX + PADDING
                @window.setOffsetX(pos.x - PADDING)


