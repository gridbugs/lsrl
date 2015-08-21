define [
    \tile
    \types
    \canvas_tile
], (tile, Types, canvas_tile) ->

    const FONT_SIZE = 14
    const VERTICAL_PADDING = 2
    const HORIZONTAL_PADDING = 0

    const PlayerCharacterChar = canvas_tile.AsciiPlayerCharacterStyle[0]
    const PlayerCharacterColour = canvas_tile.AsciiPlayerCharacterStyle[1]

    const UnseenColour = canvas_tile.UnseenColour

    console.debug tile.Tiles
    console.debug Types.Tile

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
            type = tile.fromCell cell
            @ctx.fillStyle = canvas_tile.AsciiTileStyles[type][1]
            @ctx.fillText canvas_tile.AsciiTileStyles[type][0], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

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
            @ctx.fillStyle = canvas_tile.AsciiTileStyles[cell.type][1]
            @ctx.fillText canvas_tile.AsciiTileStyles[cell.type][0], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2
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

        drawGrid: (grid) ->
            @ctx.beginPath!
            @__clear!
            @__drawGrid grid
            @ctx.fill!

        __drawKnowledgeCell: (cell, game_state) ->
            if cell.known
                type = tile.fromCell cell
                if cell.timestamp == game_state.absoluteTime
                    colour = canvas_tile.AsciiTileStyles[type][1]
                else
                    colour = UnseenColour
                @ctx.fillStyle = colour
                @ctx.fillText canvas_tile.AsciiTileStyles[type][0], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2
            else
                type = Types.Tile.Unknown
                @ctx.fillStyle = canvas_tile.AsciiTileStyles[type][1]
                @ctx.fillText canvas_tile.AsciiTileStyles[type][0], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2



        drawCharacterKnowledge: (character, game_state) ->
            @ctx.beginPath!
            @__clear!
            character.knowledge.grid.forEach (c) ~>
                @__drawKnowledgeCell c, game_state
            @__drawPlayerCharacter character
            @ctx.fill!

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @ctx.beginPath!
            @__clear!
            character.knowledge.grid.forEach (c) ~>
                @__drawKnowledgeCell c, game_state

            @ctx.fillStyle = canvas_tile.SelectColour
            @ctx.fillRect select_coord.x * @cellWidth, select_coord.y * @cellHeight, @cellWidth, @cellHeight

            cell = character.knowledge.grid.getCart select_coord
            if cell.game_cell.position.equals character.position
                x = character.position.x
                y = character.position.y
                @ctx.fillStyle = PlayerCharacterColour
                @ctx.fillText PlayerCharacterChar, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2
            else if cell.known
                type = tile.fromCell cell
                if cell.timestamp == game_state.absoluteTime
                    colour = canvas_tile.AsciiTileStyles[type][1]
                else
                    colour = UnseenColour
                @ctx.fillStyle = colour
                @ctx.fillText canvas_tile.AsciiTileStyles[type][0], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2
                @__drawPlayerCharacter character
            else
                type = Types.Tile.Unknown
                @ctx.fillStyle = canvas_tile.AsciiTileStyles[type][1]
                @ctx.fillText canvas_tile.AsciiTileStyles[type][0], cell.x * @cellWidth + HORIZONTAL_PADDING/2, cell.y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2
                @__drawPlayerCharacter character

            @ctx.fill!

        print: (str) ->
            log = document.getElementById("log");
            log.innerHTML += "#{str}<br/>"
            log.scrollTop = log.scrollHeight


    { CanvasDrawer }
