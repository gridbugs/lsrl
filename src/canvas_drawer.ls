define [
    \tile
    \canvas_tile
], (tile, canvas_tile) ->

    const FONT_SIZE = 14
    const VERTICAL_PADDING = 2
    const HORIZONTAL_PADDING = 0


    TileChars = []
    TileColours = []
    for i in tile.TileNames
        TileChars.push canvas_tile.AsciiTileStyles[i][0]
        TileColours.push canvas_tile.AsciiTileStyles[i][1]

    const PlayerCharacterChar = canvas_tile.AsciiPlayerCharacterStyle[0]
    const PlayerCharacterColour = canvas_tile.AsciiPlayerCharacterStyle[1]

    class CanvasDrawer
        (@canvas, @numCols, @numRows) ->
            @ctx = @canvas.getContext '2d'
            @ctx.font = "#{FONT_SIZE}px Monospace"
            @cellWidth = @ctx.measureText('@').width + HORIZONTAL_PADDING
            @cellHeight = FONT_SIZE + VERTICAL_PADDING
            @gridWidth = @cellWidth * @numCols
            @gridHeight = @cellHeight * @numRows

        __clear: ->
            @ctx.fillStyle = '#000000'
            @ctx.fillRect 0, 0, @gridWidth, @gridHeight

        __drawCell: (cell) ->
            @ctx.fillStyle = TileColours[cell.type]
            @ctx.fillText TileChars[cell.type], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

        __drawPlayerCharacter: (pc) ->
            x = pc.position.x
            y = pc.position.y
            @ctx.fillStyle = '#000000'
            @ctx.fillRect x * @cellWidth, y * @cellHeight, @cellWidth, @cellHeight
            @ctx.fillStyle = PlayerCharacterColour
            @ctx.fillText PlayerCharacterChar, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

        drawCell: (cell) ->
            @ctx.beginPath!
            @ctx.fillStyle = '#000000'
            @ctx.fillRect cell.x * @cellWidth, cell.y * @cellHeight, @cellWidth, @cellHeight
            @ctx.fillStyle = TileColours[cell.type]
            @ctx.fillText TileChars[cell.type], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2
            @ctx.fill!

        __drawGrid: (grid) ->
            grid.forEach (c) ~> @__drawCell c

        drawPlayerCharacter: (pc) ->
            x = pc.position.x
            y = pc.position.y
            @ctx.beginPath!
            @ctx.fillStyle = '#000000'
            @ctx.fillRect x * @cellWidth, y * @cellHeight, @cellWidth, @cellHeight
            @ctx.fillStyle = PlayerCharacterColour
            @ctx.fillText PlayerCharacterChar, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2
            @ctx.fill!

        drawGameState: (game_state) ->
            @ctx.beginPath!
            @__clear!
            @__drawGrid game_state.grid
            @__drawPlayerCharacter game_state.playerCharacter
            @ctx.fill!


    { CanvasDrawer }
