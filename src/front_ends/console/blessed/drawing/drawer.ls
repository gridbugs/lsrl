define [
    'front_ends/console/colours'
    'drawing/tile'
    'util'
    'types'
], (Colours, Tile, Util, Types) ->

    class Drawer
        (@program, @tileTable, @specialColours, @left, @top, @width, @height) ->
            @setDefaultBackground()
            @program.clear()

        setDefaultBackground: ->
            @setBackground(Colours.Black)

        clearDefaultBackground: ->
            @clearBackground(Colours.Black)

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

        _drawCharacterKnowledge: (character) ->

            character.getKnowledge().grid.forEach (c) ~>
                @drawKnowledgeCell(c, character.getTurnCount())
        
        drawCharacterKnowledge: (character) ->
            @_drawCharacterKnowledge(character)
            @program.flushBuffer()

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @_drawCharacterKnowledge(character)
            cell = character.getKnowledge().grid.getCart(select_coord)
            @setCursorCart(cell)

            @clearDefaultBackground()
            @setBackground(@specialColours.Selected)
            if cell.known
                tile = @tileTable[Tile.fromCell(cell)]
                @drawTile(tile)
            else
                @drawUnknownTile()
            @clearBackground(@specialColours.Selected)
            @setDefaultBackground()

            @program.flushBuffer()
