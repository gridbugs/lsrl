export vec2 = (x, y) -> new Vec2 x, y

export class Vec2
    (x, y) ->
        @x = x
        @y = y

    toString: -> "(#{@x}, #{@y})"

    add: (v) -> vec2 (@x + v.x), (@y + v.y)
    subtract: (v) -> vec2 (@x - v.x), (@y - v.y)
    dot: (v) -> @x * v.x + @y * v.y
