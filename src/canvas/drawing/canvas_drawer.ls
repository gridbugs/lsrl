define [
    'drawing/tile'
    'types'
    'canvas/drawing/canvas_tile'
], (Tile, Types, CanvasTile) ->

    const FONT_SIZE = 14
    const VERTICAL_PADDING = 2
    const HORIZONTAL_PADDING = 0

    const UnseenColour = CanvasTile.UnseenColour

    class CanvasDrawer
        (@canvas, @numCols, @numRows, @input) ->
            @baseFont = "#{FONT_SIZE}px Monospace"

            @ctx = @canvas.getContext '2d'
            @ctx.font = @baseFont
            @cellWidth = @ctx.measureText('@').width + HORIZONTAL_PADDING
            @cellHeight = FONT_SIZE + VERTICAL_PADDING
            @gridWidth = @cellWidth * @numCols
            @gridHeight = @cellHeight * @numRows
            @clearColour = '#000000'

            @boldQueue = []

        __clearAll: ->
            @ctx.fillStyle = @clearColour
            @ctx.fillRect 0, 0, @gridWidth, @gridHeight

        __fillText: (x, y, text, colour, style) ->
            @ctx.fillStyle = colour

            if style?
                @boldQueue.push([x, y, text, colour])
            else
                @ctx.fillText text, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

        __fillTextCart: (v, text, colour, style) ->
            @__fillText(v.x, v.y, text, colour, style)

        __fillTextFromTileType: (x, y, type) ->
            @__fillText(x, y, CanvasTile.AsciiTileStyles[type][0], CanvasTile.AsciiTileStyles[type][1], CanvasTile.AsciiTileStyles[type][2])

        __fillTextFromTileTypeCart: (v, type) ->
            @__fillTextFromTileType(v.x, v.y, type)

        __fillTextFromCell: (cell) ->
            @__fillTextFromTileType(cell.x, cell.y, Tile.fromCell(cell))

        __fillTextFromCellWithColour: (cell, colour) ->
            tile = CanvasTile.AsciiTileStyles[Tile.fromCell(cell)]
            @__fillText(cell.x, cell.y, tile[0], colour, tile[1])

        __fillBackground: (x, y, colour) ->
            @ctx.fillStyle = colour
            @ctx.fillRect x * @cellWidth, y * @cellHeight, @cellWidth, @cellHeight

        __fillBackgroundCart: (v, colour) ->
            @__fillBackground(v.x, v.y, colour)

        __fillUnknownCart: (v) ->
            @__fillTextFromTileTypeCart(v, Types.Tile.Unknown)


        __clearCart: (v) ->
            @__fillBackgroundCart(v, @clearColour)

        __drawPlayerCharacter: (pc) ->
            #@__fillTextCart(pc.position, PlayerCharacterChar, PlayerCharacterColour)

        __drawCell: (cell) ->
            @__fillTextFromCell(cell)

        __drawGrid: (grid) ->
            grid.forEach (c) ~> @__drawCell c

        drawPlayerCharacter: (pc) ->
            #@ctx.beginPath!
            #@__drawPlayerCharacter pc
            #@ctx.fill!

        drawGameState: (game_state) ->
            @ctx.beginPath!
            @__clearAll!
            @__drawGrid game_state.grid
            #@__drawPlayerCharacter game_state.playerCharacter
            @ctx.fill!

        drawGrid: (grid) ->
            @ctx.beginPath!
            @__clearAll!
            @__drawGrid grid
            @ctx.fill!

        __drawKnowledgeCell: (cell, turn_count) ->
            if cell.known
                if cell.timestamp == turn_count
                    @__fillTextFromCell(cell)
                else
                    @__fillTextFromCellWithColour(cell, UnseenColour)
            else
                @__fillUnknownCart(cell)

        __processBoldQueue: ->
            @ctx.font = "bold #{@baseFont}"
            while @boldQueue.length > 0
                [x, y, text, colour] = @boldQueue.pop()
                @ctx.fillStyle = colour
                @ctx.fillText text, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

            @ctx.font = @baseFont

        __drawCharacterKnowledge: (character, game_state) ->
            character.getKnowledge().grid.forEach (c) ~>
                @__drawKnowledgeCell(c, character.getTurnCount())


        drawCharacterKnowledge: (character, game_state) ->
            @ctx.beginPath()
            @__clearAll()

            @__drawCharacterKnowledge(character, game_state)
            @__processBoldQueue()

            @ctx.fill()

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @ctx.beginPath()
            @__clearAll()

            @__fillBackgroundCart(select_coord, CanvasTile.SelectColour)
            @__drawCharacterKnowledge(character, game_state)
            @__processBoldQueue()

            @ctx.fill()

    {
        CanvasDrawer
    }
