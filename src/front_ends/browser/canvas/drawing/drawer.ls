define [
    'drawing/drawer'
    'drawing/tile'
    'structures/grid_window'
    'types'
    'front_ends/browser/canvas/drawing/tile'
], (Drawer, Tile, GridWindow, Types, CanvasTile) ->

    const FONT_SIZE = 14
    const VERTICAL_PADDING = 2
    const HORIZONTAL_PADDING = 0

    class CanvasDrawer extends Drawer
        (@canvas, @numCols, @numRows, @input) ->

            super(@numCols, @numRows)

            @baseFont = "#{FONT_SIZE}px Monospace"

            @ctx = @canvas.getContext '2d'
            @ctx.font = @baseFont
            @cellWidth = @ctx.measureText('@').width + HORIZONTAL_PADDING
            @cellHeight = FONT_SIZE + VERTICAL_PADDING
            @gridWidth = @cellWidth * @numCols
            @gridHeight = @cellHeight * @numRows
            @clearColour = '#000000'

            @boldQueue = []

            @window = new GridWindow(0, 0, @numCols, @numRows)

        __clearAll: ->
            @ctx.fillStyle = @clearColour
            @ctx.fillRect 0, 0, @gridWidth, @gridHeight

        __fillText: (x, y, text, colour, style) ->
            @ctx.fillStyle = colour

            if style
                @boldQueue.push([x, y, text, colour])
            else
                @ctx.fillText text, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

        __fillTextCart: (v, text, colour, style) ->
            @__fillText(v.x, v.y, text, colour, style)

        __fillTextFromTileType: (x, y, type) ->
            @__fillText(x, y, CanvasTile.TileStyles[type].character,
                              CanvasTile.TileStyles[type].colour,
                              CanvasTile.TileStyles[type].bold
            )

        __fillTextFromTileTypeCart: (type, x, y) ->
            @__fillTextFromTileType(x, y, type)

        __fillTextFromCell: (cell, x, y) ->
            @__fillTextFromTileType(x, y, Tile.fromCell(cell))

        __fillTextFromCellWithColour: (cell, colour, x, y) ->
            tile = CanvasTile.TileStyles[Tile.fromCell(cell)]
            @__fillText(x, y, tile.character, colour, tile.colour)

        __fillBackground: (x, y, colour) ->
            @ctx.fillStyle = colour
            @ctx.fillRect x * @cellWidth, y * @cellHeight, @cellWidth, @cellHeight

        __fillBackgroundCart: (v, colour) ->
            @__fillBackground(v.x, v.y, colour)

        __fillUnknownCart: (x, y) ->
            @__fillTextFromTileTypeCart(Types.Tile.Unknown, x, y)


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

        __drawKnowledgeCell: (cell, turn_count, x, y) ->
            if cell? and cell.known
                if cell.timestamp == turn_count
                    @__fillTextFromCell(cell, x, y)
                else
                    @__fillTextFromCellWithColour(cell, CanvasTile.SpecialColours.Unseen, x, y)
            else
                @__fillUnknownCart(x, y)

        __processBoldQueue: ->
            @ctx.font = "bold #{@baseFont}"
            while @boldQueue.length > 0
                [x, y, text, colour] = @boldQueue.pop()
                @ctx.fillStyle = colour
                @ctx.fillText text, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + \
                    FONT_SIZE - VERTICAL_PADDING/2

            @ctx.font = @baseFont

        __drawCharacterKnowledge: (character) ->

            grid = character.getKnowledge().grid
            @adjustWindow(character, grid)

            @window.forEach grid, (c, i, j) ~>
                @__drawKnowledgeCell(c, character.getTurnCount(), j, i)


        drawCharacterKnowledge: (character, game_state) ->
            @ctx.beginPath()
            @__clearAll()

            @__drawCharacterKnowledge(character, game_state)
            @__processBoldQueue()

            @ctx.fill()

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @ctx.beginPath()
            @__clearAll()
            @__fillBackgroundCart(select_coord, CanvasTile.SpecialColours.Selected)
            @__drawCharacterKnowledge(character, game_state)
            @__processBoldQueue()

            @ctx.fill()
