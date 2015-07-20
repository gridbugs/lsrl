export class CursesDrawer
    (ncurses, game_window) ->
        @ncurses = ncurses
        @game_window = game_window
        @game_window.attrset(@ncurses.colorPair(3))
        @game_window.refresh!

    draw: (game_state) ->
        @game_window.attrset(@ncurses.colorPair(3))
        @game_window.addstr("hello\n\r")
        @game_window.refresh!
