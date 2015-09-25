define [
    'blessed'
    'front_ends/console/colours'
    'front_ends/console/text'
    'drawing/tile'
    'util'
    'types'
], (Blessed, Colours, Text, Tile, Util, Types) ->

    class Drawer
        (@program, @tileTable, @specialColours, @left, @top, @width, @height) ->
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
            @drawCharacter(tile.character, @specialColours.Unseen, tile.bold)

        drawUnknownTile: ->
            @drawTile(@tileTable[Types.Tile.Unknown])

        drawKnowledgeCell: (cell, turn_count) ->
            if cell.known
                tile = @tileTable[Tile.fromCell(cell)]
                if cell.timestamp == turn_count
                    @drawTile(tile)
                else
                    @drawUnseenTile(tile)
            else
                @drawUnknownTile()

        _drawCharacterKnowledge: (character) ->

            turncount = character.getTurnCount()
            grid = character.getKnowledge().grid

            @program.move(0, 0)

            for i from 0 til grid.height
                for j from 0 til grid.width
                    @drawKnowledgeCell(grid.get(j, i), turncount)
                @program.write("\n\r")

        drawCharacterKnowledge: (character) ->
            @_drawCharacterKnowledge(character)
            @program.flushBuffer()

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @_drawCharacterKnowledge(character)
            cell = character.getKnowledge().grid.getCart(select_coord)
            @setCursorCart(cell)

            @setBackground(@specialColours.Selected)
            if cell.known
                tile = @tileTable[Tile.fromCell(cell)]
                @drawTile(tile)
            else
                @drawUnknownTile()
            @setDefaultBackground()

            @program.flushBuffer()
