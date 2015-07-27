require! requirejs
requirejs.config { nodeRequire: require }

requirejs [\vec2, 'prelude-ls', 'direction'
    'grid', 'control', 'keymap'
    ],  (vec2, prelude, direction, grid, control,
    keymap) ->

    map = prelude.map

    a = vec2.Vec2 4, 3
    b = vec2.Vec2 7, 2
    c = a.add b
    console.log c

    console.log ([1, 2, 3, 4] |> map (x) -> x*2)

    console.log direction.AllDirections
    console.log direction.Indices
    class Cell
        (x, y) ->
            @x = x
            @y = y
        toString: -> "(#{@x} #{@y})"

    g = new grid.Grid Cell, 10, 10
    console.log "#{g}"

    console.log control.Controls

    console.log keymap.Qwerty
