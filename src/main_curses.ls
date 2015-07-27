require! requirejs
requirejs.config { nodeRequire: require }

requirejs [\curses_game], (game_curses) ->
    game_curses.main!
