require! './Tiles.ls': {TileTypes}
require! './CursesTiles.ls': {Colours, TileStyles}

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
for i in TileTypes
    TileChars.push TileStyles[i][0]
    TileColours.push ColourPairs[TileStyles[i][1]]

export class CursesDrawer
    (ncurses, game_window, hud_window, log_window) ->
        @ncurses = ncurses
        @game_window = game_window
        @hud_window = hud_window
        @log_window = log_window

        /* Initialize each colour pair.
         * This is done in the constructor as it requires an ncurses context.
         */
        for k, v of ColourPairs
            @ncurses.colorPair v, Colours[k], Colours.BLACK

    __drawCell: (cell) ->
        @game_window.cursor cell.y, cell.x
        @game_window.attrset @ncurses.colorPair(TileColours[cell.type])
        @game_window.addstr TileChars[cell.type]

    drawCell: (cell) ->
        @__drawCell cell
        @game_window.refresh!

    drawGrid: (grid) ->
        @game_window.border!
        grid.forEach (c) ~> @__drawCell c
        @game_window.refresh!
