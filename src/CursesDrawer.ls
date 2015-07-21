export class CursesDrawer
    (ncurses, game_window, hud_window, log_window) ->
        @ncurses = ncurses
        @game_window = game_window
        @hud_window = hud_window
        @log_window = log_window

        @game_window.addstr "game"
        @hud_window.addstr "hud"
        @log_window.addstr "log"

        @game_window.refresh!
        @game_window.top!

    draw: (game_state) ->
        @game_window.addstr("hello\n\r")
        @game_window.refresh!
        @hud_window.addstr("hello\n\r")
        @hud_window.refresh!
        @log_window.addstr("hello\n\r")
        @log_window.refresh!
        process.stderr.write "aoeu\n"

