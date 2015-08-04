define [
    \ncurses
    \tile 
    \curses_tile
    \util
], (ncurses, tile, curses_tile, Util) ->

    Colours = curses_tile.Colours
    TileStyles = curses_tile.TileStyles
    PlayerCharacterStyle = curses_tile.PlayerCharacterStyle

    const PAIR_MIN = 16 /* Minimum number for ncurses colour pairs */

    /* Choose numbers to use for colour pairs for each specified colour.
     * Each colour pair will have the specified colour as the foreground
     * and a black background.
     */
    ColourPairs = {}
    let i = PAIR_MIN
        for k, v of Colours
            ColourPairs[k] = i++

    /* Build arrays for tile chars and colours corresponding
     * to the TileStyles object.
     */
    TileChars = []
    TileColours = []
    for i in tile.TileNames
        TileChars.push TileStyles[i][0]
        TileColours.push ColourPairs[TileStyles[i][1]]

    for i from 0 to 25
        TileChars.push '#'
        TileColours.push 232+i

    const PlayerCharacterChar = PlayerCharacterStyle[0]
    const PlayerCharacterColour = ColourPairs[PlayerCharacterStyle[1]]

    const UnseenColour = ColourPairs.VERY_DARK_GREY

    class CursesDrawer
        ->
            @stdscr = new ncurses.Window!
            @game_window = new ncurses.Window(40, 120, 0, 0)
            @hud_window = new ncurses.Window(47, 40, 0, 122)
            @log_window = new ncurses.Window(6, 120, 41, 0)
            @log_window.scrollok true
            ncurses.showCursor = false
            ncurses.echo = false

            /* Initialize each colour pair.
             * This is done in the constructor as it requires an ncurses context.
             */
            for k, v of ColourPairs
                ncurses.colorPair v, Colours[k], Colours.BLACK
        getGameWindow: -> @game_window

        cleanup: ~>
            @stdscr.close!
            @game_window.close!
            @hud_window.close!
            @log_window.close!
            ncurses.cleanup!

        __drawCell: (cell) ->
            @game_window.cursor cell.y, cell.x
            type = tile.fromCell cell
            @game_window.attrset ncurses.colorPair(TileColours[type])
            @game_window.addstr TileChars[type]

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
            @game_window.attrset ncurses.colorPair(PlayerCharacterColour)
            @game_window.addstr PlayerCharacterChar

        drawGameState: (game_state) ->
            @__drawGrid game_state.grid
            @__drawPlayerCharacter game_state.playerCharacter
            @game_window.refresh!

        __drawUnknown: (x, y) ->
            @game_window.cursor y, x
            u = tile.Tiles.UNKNOWN
            @game_window.attrset ncurses.colorPair(TileColours[u])
            @game_window.addstr TileChars[u]


        __drawKnowledgeCell: (cell, game_state) ->
            @game_window.cursor cell.y, cell.x
            if cell.known
                colour = void
                type = tile.fromCell cell
                if cell.timestamp == game_state.absoluteTime
                    colour = TileColours[type]
                else
                    colour = UnseenColour
                @game_window.attrset ncurses.colorPair(colour)
                @game_window.addstr TileChars[type]

            else
                u = tile.Tiles.UNKNOWN
                @game_window.attrset ncurses.colorPair(TileColours[u])
                @game_window.addstr TileChars[u]


        drawCharacterKnowledge: (character, game_state) ->
            character.knowledge.grid.forEach (c) ~>
                @__drawKnowledgeCell c, game_state
            @__drawPlayerCharacter character
            @game_window.refresh!

        print: (str) ->
            @log_window.addstr("#{str}\n\r")
            @log_window.refresh!

    { CursesDrawer }
