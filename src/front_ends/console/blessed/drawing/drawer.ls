define [
    'front_ends/console/colours'
    'drawing/tile'
    'util'
    'types'
], (Colours, Tile, Util, Types) ->

    class Drawer
        (@program, @tileTable, @specialColours, @left, @top, @width, @height) ->
            @setBackground(Colours.Black)
            @program.clear()

        setBackground: (colourId) ->
            @program.bg("#{colourId}")

        clearBackground: (colourId) ->
            @program.bg("!#{colourId}")

        setForeground: (colourId) ->
            @program.fg("#{colourId}")

        clearForeground: (colourId) ->
            @program.fg("!#{colourId}")

        setBold: ->
            @program.attr('bold', true)

        clearBold: ->
            @program.attr('bold', false)

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
            @clearForeground(colour)

        drawTile: (tile) ->
            @drawCharacter(tile.character, tile.colour, tile.bold)

        drawUnseenTile: (tile) ->
            @drawCharacter(tile.character, @specialColours.Unseen, tile.bold)

        drawUnknownTile: ->
            @drawTile(@tileTable[Types.Tile.Unknown])

        drawKnowledgeCell: (cell, turn_count) ->
            @setCursorCart(cell)
            if cell.known
                tile = @tileTable[Tile.fromCell(cell)]
                if cell.timestamp == turn_count
                    @drawTile(tile)
                else
                    @drawUnseenTile(tile)
            else
                @drawUnknownTile()

        drawCharacterKnowledge: (character) ->

            character.getKnowledge().grid.forEach (c) ~>
                @drawKnowledgeCell(c, character.getTurnCount())

            @program.flushBuffer()

        drawCellSelectOverlay: ->
