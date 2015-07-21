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
            @ncurses.colorPair v, Colours[k], @ncurses.colors.BLACK

    drawGrid: (grid) ->
        @game_window.border!
        @game_window.attrset @ncurses.colorPair(ColourPairs.LIGHT_BLUE)

        @game_window.addstr "hello" + Object.keys(ColourPairs)
        @game_window.refresh!

    draw: (game_state) ->
        @game_window.addstr("hello\n\r")
        @game_window.refresh!
        @hud_window.addstr("hello\n\r")
        @hud_window.refresh!
        @log_window.addstr("hello\n\r")
        @log_window.refresh!
        process.stderr.write "aoeu\n"

