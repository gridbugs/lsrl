define [
    'ncurses'
    'drawing/tile'
    'curses/drawing/curses_tile'
    'types'
    'util'
], (Ncurses, Tile, CursesTile, Types, Util) ->

    TileStyles = CursesTile.TileStyles

    const PAIR_MIN = 16 /* Minimum number for ncurses colour pairs */

    ColourPairs = []
    let i = PAIR_MIN
        for k, v of CursesTile.ColourType
            ColourPairs[v] = i
            ++i

    for s in TileStyles
        s.pair = ColourPairs[s.colour]

    const UnseenPair = ColourPairs[CursesTile.SpecialColours.Unseen]
    const SelectColourPair = 100

    class CursesDrawer
        ->
            @ncurses = Ncurses
            @stdscr = new Ncurses.Window()
            width = 80
            @gameWindow = new Ncurses.Window(30, width, 0, 0)
            @hudWindow = new Ncurses.Window(4, width, @gameWindow.height, 0)
            @logWindow = new Ncurses.Window(12, width, @gameWindow.height + @hudWindow.height, 0)
            Ncurses.showCursor = false
            Ncurses.echo = false
            Ncurses.setEscDelay 0

            @buf = [[void] * @gameWindow.width] * @gameWindow.height
            @cursor_x = 0
            @cursor_y = 0

            /* Initialize each colour pair.
             * This is done in the constructor as it requires an Ncurses context.
             */
            for e in Util.enumerateDefined(ColourPairs)
                k = e[0]; v = e[1]
                Ncurses.colorPair v, k, CursesTile.ColourType.Black

            Ncurses.colorPair SelectColourPair, CursesTile.ColourType.Black, CursesTile.ColourType.Yellow

            @logWindowCallback = (->)
            @logWindow.on 'inputChar', (c, k) ~>
                @logWindowCallback(c, k)

            @gameWindow.top()

        getGameWindow: -> @gameWindow

        cleanup: ~>
            @stdscr.close()
            @gameWindow.close()
            @hudWindow.close()
            @logWindow.close()
            Ncurses.cleanup()

        __setCursor: (x, y) ->
            @gameWindow.cursor(y, x)
            @cursor_x = x
            @cursor_y = y

        __setCursorCart: (v) ->
            @__setCursor(v.x, v.y)

        __drawCell: (cell) ->
            @__setCursorCart cell
            tile = TileStyles[Tile.fromCell(cell)]
            @__drawTile(tile)

        drawCell: (cell) ->
            @__drawCell cell
            @gameWindow.refresh!

        __drawGrid: (grid) ->
            grid.forEach (c) ~> @__drawCell c

        drawGrid: (grid) ->
            @__drawGrid grid
            @gameWindow.refresh!


        drawGameState: (game_state) ->
            @__drawGrid game_state.grid
            @gameWindow.refresh!

        __drawUnknown: (x, y) ->
            @__setCursor(x, y)
            tile = TileStyles[Types.Tile.Unknown]
            @__drawTile(tile)

        __drawUnknownCart: (v) ->
            @__drawUnknown(v.x, v.y)

        __drawChar: (char, colour_pair, bold) ->

            if bold? and bold
                style = Ncurses.attrs.BOLD
            else
                style = Ncurses.attrs.NORMAL

            @gameWindow.attrset(Ncurses.colorPair(colour_pair) .|. style)
            @gameWindow.addstr char
            @buf[@cursor_y][@cursor_x] = char

        __drawTile: (tile) ->
            @__drawChar(tile.character, tile.pair, tile.bold)

        __drawUnseenTile: (tile) ->
            @__drawChar(tile.character, UnseenPair, tile.bold)

        __drawKnowledgeCell: (cell, turn_count) ->
            @__setCursorCart cell
            if cell.known
                tile = TileStyles[Tile.fromCell(cell)]
                if cell.timestamp == turn_count
                    @__drawTile(tile)
                else
                    @__drawUnseenTile(tile)
            else
                @__drawUnknownCart(cell)

        __drawCharacterKnowledge: (character, game_state) ->
            character.getKnowledge().grid.forEach (c) ~>
                @__drawKnowledgeCell(c, character.getTurnCount())

        drawCharacterKnowledge: (character, game_state) ->
            @__drawCharacterKnowledge(character, game_state)
            @gameWindow.refresh()

        __getCurrentChar: -> @buf[@cursor_y][@cursor_x]

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @__drawCharacterKnowledge(character, game_state)

            cell = character.getKnowledge().grid.getCart select_coord
            @__setCursorCart cell

            if cell.known
                type = Tile.fromCell cell
                tile = TileStyles[type]
                @__drawChar(tile.character, SelectColourPair)
            else
                tile = TileStyles[Types.Tile.Unknown]
                @__drawChar(tile.character, SelectColourPair)

            @gameWindow.refresh!

    {
        CursesDrawer
    }
