define [
    'assets/assets'
    'drawing/drawer'
    'front_ends/console/colours'
    'front_ends/console/text'
    'interface/user_interface'
    'util'
    'types'
    'asset_system'
], (Assets, Drawer, Colours, Text, UserInterface, Util, Types, AssetSystem) ->

    UNSEEN_COLOUR = Colours.VeryDarkGrey
    SELECTED_COLOUR = Colours.DarkYellow

    class BlessedUnicodeDrawer extends Drawer
        (@program, @left, @top, @width, @height) ->

            super(@width, @height)

            @setDefaultBackground()
            @program.clear()

        setDefaultBackground: ->
            @setBackground(Colours.Black)

        setBackground: (colourId) ->
            @program.write(Text.setBackgroundColour(colourId))

        setForeground: (colourId) ->
            @program.write(Text.setForegroundColour(colourId))

        setBold: ->
            @program.write(Text.setBoldWeight())

        clearBold: ->
            @program.write(Text.setNormalWeight())

        write: (str) ->
            @program.write(str)

        setCursorCart: (v) ->
            @program.setx(v.x)
            @program.sety(v.y)

        drawCharacter: (character, colour, bold) ->
            @setForeground(colour)
            if bold
                @setBold()
            @write(character)
            if bold
                @clearBold()

        drawTile: (tile) ->
            @drawCharacter(tile.character, tile.colour, tile.bold)

        drawUnseenTile: (tile) ->
            @drawCharacter(tile.character, UNSEEN_COLOUR, tile.bold)

        drawUnknownTile: ->
            @drawTile(Assets.TileSet.Default.Tiles.Unknown)

        getTileFromCell: (cell) ->
            return cell.getTile()

        drawKnowledgeCell: (cell, turn_count) ->
            if cell? and cell.known
                tile = @getTileFromCell(cell)
                if cell.timestamp == turn_count
                    @drawTile(tile)
                else
                    @drawUnseenTile(tile)
            else
                @drawUnknownTile()

        _drawCharacterKnowledge: (character) ->

            turncount = character.getTurnCount()
            grid = character.getKnowledge().getGrid()

            @adjustWindow(character, grid)

            @program.move(0, 0)

            for i from 0 til @window.height
                for j from 0 til @window.width
                    @drawKnowledgeCell(@window.get(grid, j, i), turncount)
                @program.write("\n\r")

        drawCharacterKnowledge: (character) ->
            @_drawCharacterKnowledge(character)
            @program.flushBuffer()

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @_drawCharacterKnowledge(character)
            cell = character.getKnowledge().getGrid().getCart(select_coord)
            @setCursorCart(cell)

            @setBackground(SELECTED_COLOUR)
            if cell.known
                tile = @getTileFromCell(cell)
                @drawTile(tile)
            else
                @drawUnknownTile()
            @setDefaultBackground()

            @program.flushBuffer()

    AssetSystem.exposeAsset('Drawer', BlessedUnicodeDrawer)
