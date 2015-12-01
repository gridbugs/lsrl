define [
    'assets/assets'
    'drawing/drawer'
    'structures/grid_window'
    'types'
    'asset_system'
], (Assets, Drawer, GridWindow, Types, AssetSystem) ->

    const FONT_SIZE = 14
    const VERTICAL_PADDING = 2
    const HORIZONTAL_PADDING = 0

    const UNSEEN_COLOUR = '#333333'
    const SELECTED_COLOUR = '#888800'
    const CLEAR_COLOUR = '#000000'

    class CanvasUnicodeDrawer extends Drawer
        (@canvas, @numCols, @numRows) ->

            super(@numCols, @numRows)

            @baseFont = "#{FONT_SIZE}px Monospace"

            @ctx = @canvas.getContext '2d'
            @ctx.font = @baseFont
            @cellWidth = @ctx.measureText('@').width + HORIZONTAL_PADDING
            @cellHeight = FONT_SIZE + VERTICAL_PADDING
            @gridWidth = @cellWidth * @numCols
            @gridHeight = @cellHeight * @numRows

            @boldQueue = []

            @window = new GridWindow(0, 0, @numCols, @numRows)

        tileFromCell: (cell) ->
            return cell.getTile(cell.timestamp)

        __clearAll: ->
            @ctx.fillStyle = CLEAR_COLOUR
            @ctx.fillRect 0, 0, @gridWidth, @gridHeight

        __fillText: (x, y, text, colour, style) ->
            @ctx.fillStyle = colour

            if style
                @boldQueue.push([x, y, text, colour])
            else
                @ctx.fillText text, x * @cellWidth + HORIZONTAL_PADDING/2, y * @cellHeight + FONT_SIZE - VERTICAL_PADDING/2

        __fillTextFromTile: (x, y, tile) ->
            @__fillText(x, y, tile.character,
                              tile.colour,
                              tile.bold
            )

        __fillTextFromCell: (cell, x, y) ->
            @__fillTextFromTile(x, y, @tileFromCell(cell))

        __fillTextFromCellWithColour: (cell, colour, x, y) ->
            tile = @tileFromCell(cell)
            @__fillText(x, y, tile.character, colour, tile.colour)

        __fillBackground: (x, y, colour) ->
            @ctx.fillStyle = colour
            @ctx.fillRect x * @cellWidth, y * @cellHeight, @cellWidth, @cellHeight

        __fillBackgroundCart: (v, colour) ->
            @__fillBackground(v.x, v.y, colour)

        __fillUnknownCart: (x, y) ->
            @__fillTextFromTile(x, y, Assets.TileSet.Default.Tiles.Unknown)

        __drawKnowledgeCell: (cell, turn_count, x, y) ->
            if cell? and cell.known
                if cell.timestamp == turn_count
                    @__fillTextFromCell(cell, x, y)
                else
                    @__fillTextFromCellWithColour(cell, UNSEEN_COLOUR, x, y)
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

            grid = character.getKnowledge().getGrid()
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
            @__fillBackgroundCart(select_coord, SELECTED_COLOUR)
            @__drawCharacterKnowledge(character, game_state)
            @__processBoldQueue()

            @ctx.fill()

    AssetSystem.exposeAsset('Drawer', CanvasUnicodeDrawer)
