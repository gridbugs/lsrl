require! requirejs
requirejs.config { nodeRequire: require }

requirejs [\curses_game], (curses_game) ->
    curses_game.main!
