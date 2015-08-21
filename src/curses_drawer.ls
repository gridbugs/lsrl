define [
    \ncurses
    \tile
    \curses_tile
    \types
    \util
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
            @game_window = new Ncurses.Window(40, 120, 0, 0)
            @hud_window = new Ncurses.Window(47, 40, 0, 122)
            @log_window = new Ncurses.Window(6, 120, 41, 0)
            @log_window.scrollok true
            Ncurses.showCursor = false
            Ncurses.echo = false
            Ncurses.setEscDelay 0

            /* Initialize each colour pair.
             * This is done in the constructor as it requires an Ncurses context.
             */
            for e in Util.enumerateDefined(ColourPairs)
                k = e[0]; v = e[1]
                Ncurses.colorPair v, k, CursesTile.ColourType.Black

            Ncurses.colorPair SelectColourPair, CursesTile.ColourType.Black, CursesTile.ColourType.Yellow

        getGameWindow: -> @game_window

        cleanup: ~>
            @stdscr.close!
            @game_window.close!
            @hud_window.close!
            @log_window.close!
            Ncurses.cleanup!

        __drawCell: (cell) ->
            @game_window.cursor cell.y, cell.x
            type = Tile.fromCell cell
            tile = TileStyles[type]
            @game_window.attrset Ncurses.colorPair(tile.pair)
            @game_window.addstr tile.character

        drawCell: (cell) ->
            @__drawCell cell
            @game_window.refresh!

        __drawGrid: (grid) ->
            grid.forEach (c) ~> @__drawCell c

        drawGrid: (grid) ->
            @__drawGrid grid
            @game_window.refresh!

        __drawPlayerCharacter: (pc) ->
            @game_window.cursor pc.position.y, pc.position.x
            @game_window.attrset Ncurses.colorPair(PlayerCharacterStyle.pair)
            @game_window.addstr PlayerCharacterStyle.character

        drawGameState: (game_state) ->
            @__drawGrid game_state.grid
            @__drawPlayerCharacter game_state.playerCharacter
            @game_window.refresh!

        __drawUnknown: (x, y) ->
            @game_window.cursor y, x
            tile = TileStyles[Types.Tile.Unknown]
            @game_window.attrset Ncurses.colorPair(tile.pair)
            @game_window.addstr tile.character


        __drawKnowledgeCell: (cell, game_state) ->
            @game_window.cursor cell.y, cell.x
            if cell.known
                colour = void
                type = Tile.fromCell cell
                tile = TileStyles[type]
                if cell.timestamp == game_state.absoluteTime
                    colour = tile.pair
                else
                    colour = UnseenPair
                @game_window.attrset Ncurses.colorPair(colour)
                @game_window.addstr tile.character

            else
                tile = TileStyles[Types.Tile.Unknown]
                @game_window.attrset Ncurses.colorPair(tile.pair)
                @game_window.addstr tile.character


        drawCharacterKnowledge: (character, game_state) ->
            character.knowledge.grid.forEach (c) ~>
                @__drawKnowledgeCell c, game_state
            @__drawPlayerCharacter character
            @game_window.refresh!

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            character.knowledge.grid.forEach (c) ~>
                @__drawKnowledgeCell c, game_state
            @__drawPlayerCharacter character
            @game_window.refresh!

            cell = character.knowledge.grid.getCart select_coord
            @game_window.cursor cell.y, cell.x

            if cell.game_cell.position.equals character.position
                @game_window.attrset Ncurses.colorPair(SelectColourPair)
                @game_window.addstr PlayerCharacterStyle.character
            else if cell.known
                type = Tile.fromCell cell
                tile = TileStyles[type]
                @game_window.attrset Ncurses.colorPair(SelectColourPair)
                @game_window.addstr tile.character
                @__drawPlayerCharacter character
            else
                tile = TileStyles[Types.Tile.Unknown]
                @game_window.attrset Ncurses.colorPair(SelectColourPair)
                @game_window.addstr tile.character
                @__drawPlayerCharacter character

            @game_window.refresh!


        print: (str) ->
            @log_window.addstr("#{str}\n\r")
            @log_window.refresh!

    { CursesDrawer }
