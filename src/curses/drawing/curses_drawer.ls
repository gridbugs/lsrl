define [
    'ncurses'
    'drawing/tile'
    'curses/drawing/curses_tile'
    'types'
    'util'
], (Ncurses, Tile, CursesTile, Types, Util) ->

    TileStyles = CursesTile.TileStyles
    PlayerCharacterStyle = CursesTile.PlayerCharacterStyle

    const PAIR_MIN = 16 /* Minimum number for ncurses colour pairs */

    ColourPairs = []
    let i = PAIR_MIN
        for k, v of CursesTile.ColourType
            ColourPairs[v] = i
            ++i

    for s in TileStyles
        s.pair = ColourPairs[s.colour]

    PlayerCharacterStyle.pair = ColourPairs[PlayerCharacterStyle.colour]

    const UnseenPair = ColourPairs[CursesTile.SpecialColours.Unseen]
    const SelectColourPair = 100

    class CursesDrawer
        ->
            @stdscr = new Ncurses.Window!
            @gameWindow = new Ncurses.Window(40, 120, 0, 0)
            @hudWindow = new Ncurses.Window(47, 40, 0, 122)
            @logWindow = new Ncurses.Window(6, 120, 41, 0)
            @logWindow.scrollok(true)
            Ncurses.showCursor = false
            Ncurses.echo = false
            Ncurses.setEscDelay 0

            @buf = [[void] * 120] * 40
            @cursor_x = 0
            @cursor_y = 0

            /* Initialize each colour pair.
             * This is done in the constructor as it requires an Ncurses context.
             */
            for e in Util.enumerateDefined(ColourPairs)
                k = e[0]; v = e[1]
                Ncurses.colorPair v, k, CursesTile.ColourType.Black

            Ncurses.colorPair SelectColourPair, CursesTile.ColourType.Black, CursesTile.ColourType.Yellow
            @gameWindow.top!

        getGameWindow: -> @gameWindow

        cleanup: ~>
            @stdscr.close!
            @gameWindow.close!
            @hudWindow.close!
            @logWindow.close!
            Ncurses.cleanup!

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

        __drawPlayerCharacter: (pc) ->
            @__setCursorCart pc.position
            @__drawChar(PlayerCharacterStyle.character, PlayerCharacterStyle.pair)

        drawGameState: (game_state) ->
            @__drawGrid game_state.grid
            @__drawPlayerCharacter game_state.playerCharacter
            @gameWindow.refresh!

        __drawUnknown: (x, y) ->
            @__setCursor(x, y)
            tile = TileStyles[Types.Tile.Unknown]
            @__drawTile(tile)
        
        __drawUnknownCart: (v) ->
            @__drawUnknown(v.x, v.y)

        __drawChar: (char, colour_pair) ->
            @gameWindow.attrset Ncurses.colorPair(colour_pair)
            @gameWindow.addstr char
            @buf[@cursor_y][@cursor_x] = char
            
        __drawTile: (tile) ->
            @__drawChar(tile.character, tile.pair)

        __drawUnseenTile: (tile) ->
            @__drawChar(tile.character, UnseenPair)

        __drawKnowledgeCell: (cell, game_state) ->
            @__setCursorCart cell
            if cell.known
                tile = TileStyles[Tile.fromCell(cell)]
                if cell.timestamp == game_state.absoluteTime
                    @__drawTile(tile)
                else
                    @__drawUnseenTile(tile)
            else
                @__drawUnknownCart(cell)

        __drawCharacterKnowledge: (character, game_state) ->
            character.knowledge.grid.forEach (c) ~>
                if c.position.equals(character.position)
                    @__drawPlayerCharacter(character)
                else
                    @__drawKnowledgeCell c, game_state

        drawCharacterKnowledge: (character, game_state) ->
            @__drawCharacterKnowledge(character, game_state)
            @gameWindow.refresh!

        __getCurrentChar: -> @buf[@cursor_y][@cursor_x]

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @__drawCharacterKnowledge(character, game_state)

            cell = character.knowledge.grid.getCart select_coord
            @__setCursorCart cell
            #@__drawChar(@__getCurrentChar(), SelectColourPair)


            if cell.game_cell.position.equals character.position
                @__drawChar(PlayerCharacterStyle.character, SelectColourPair)
            else if cell.known
                type = Tile.fromCell cell
                tile = TileStyles[type]
                @__drawChar(tile.character, SelectColourPair)
            else
                tile = TileStyles[Types.Tile.Unknown]
                @__drawChar(tile.character, SelectColourPair)

            @gameWindow.refresh!

        print: (str) ->
            @logWindow.addstr("#{str}\n\r")
            @logWindow.refresh!

        readLine: (f) ->
            Ncurses.showCursor = true
            @logWindow.top()
            @logWindow.refresh()
            str = ""
            @onInputChar @logWindow, (c) ~>
                if c == '\n'
                    Ncurses.showCursor = false
                    @gameWindow.top()
                    @gameWindow.refresh()
                    @onInputChar(@logWindow, (->))
                    @logWindow.addstr(c)
                    @logWindow.refresh()
                    f(str)
                else
                    str += c
                    @logWindow.addstr(c)
                    @logWindow.refresh()

        onInputChar: (w, f) ->
            w.on 'inputChar', f



    {
        CursesDrawer
    }
