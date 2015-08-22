define [
    \tile
    \types
    \canvas_tile
], (Tile, Types, CanvasTile) ->

    const FONT_SIZE = 14
    const VERTICAL_PADDING = 2
    const HORIZONTAL_PADDING = 0

    const PlayerCharacterChar = CanvasTile.AsciiPlayerCharacterStyle[0]
    const PlayerCharacterColour = CanvasTile.AsciiPlayerCharacterStyle[1]

    const UnseenColour = CanvasTile.UnseenColour

    class CanvasDrawer
        (@canvas, @numCols, @numRows) ->
            @ctx = @canvas.getContext '2d'
            @ctx.font = "#{FONT_SIZE}px Monospace"
            @cellWidth = @ctx.measureText('@').width + HORIZONTAL_PADDING
            @cellHeight = FONT_SIZE + VERTICAL_PADDING
            @gridWidth = @cellWidth * @numCols
            @gridHeight = @cellHeight * @numRows
            @clearColour = '#000000'

        __clearAll: ->
            @ctx.fillStyle = @clearColour
            @ctx.fillRect 0, 0, @gridWidth, @gridHeight

        __fillText: (x, y, text, colour) ->
            @ctx.fillStyle = colour
            @ctx.fillText text, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

        __fillTextCart: (v, text, colour) ->
            @__fillText(v.x, v.y, text, colour)

        __fillTextFromTileType: (x, y, type) ->
            @__fillText(x, y, CanvasTile.AsciiTileStyles[type][0], CanvasTile.AsciiTileStyles[type][1])

        __fillTextFromTileTypeCart: (v, type) ->
            @__fillTextFromTileType(v.x, v.y, type)

        __fillTextFromCell: (cell) ->
            @__fillTextFromTileType(cell.x, cell.y, Tile.fromCell(cell))
        
        __fillTextFromCellWithColour: (cell, colour) ->
            @__fillText(cell.x, cell.y, CanvasTile.AsciiTileStyles[Tile.fromCell(cell)][0], colour)

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
            @__fillTextCart(pc.position, PlayerCharacterChar, PlayerCharacterColour)

        __drawCell: (cell) ->
            @__fillTextFromCell(cell)
        
        __drawGrid: (grid) ->
            grid.forEach (c) ~> @__drawCell c

        drawPlayerCharacter: (pc) ->
            @ctx.beginPath!
            @__drawPlayerCharacter pc
            @ctx.fill!

        drawGameState: (game_state) ->
            @ctx.beginPath!
            @__clearAll!
            @__drawGrid game_state.grid
            @__drawPlayerCharacter game_state.playerCharacter
            @ctx.fill!

        drawGrid: (grid) ->
            @ctx.beginPath!
            @__clearAll!
            @__drawGrid grid
            @ctx.fill!

        __drawKnowledgeCell: (cell, game_state) ->
            if cell.known
                if cell.timestamp == game_state.absoluteTime
                    @__fillTextFromCell(cell)
                else
                    @__fillTextFromCellWithColour(cell, UnseenColour)
            else
                @__fillUnknownCart(cell)


        __drawCharacterKnowledge: (character, game_state) ->
            character.knowledge.grid.forEach (c) ~>
                if c.position.equals(character.position)
                    @__drawPlayerCharacter(character)
                else
                    @__drawKnowledgeCell c, game_state

        drawCharacterKnowledge: (character, game_state) ->
            @ctx.beginPath()
            @__clearAll()

            @__drawCharacterKnowledge(character, game_state)

            @ctx.fill()

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @ctx.beginPath()
            @__clearAll()

            @__fillBackgroundCart(select_coord, CanvasTile.SelectColour)
            @__drawCharacterKnowledge(character, game_state)

            @ctx.fill()
            
        print: (str) ->
            console.log str
            log = document.getElementById("log");
            log.innerHTML += "#{str}<br/>"
            log.scrollTop = log.scrollHeight


    { CanvasDrawer }
