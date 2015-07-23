export vec2 = (x, y) -> new Vec2 x, y
export vec2FromRadial = (angle, length) -> vec2 (length * Math.cos(angle)), (length * Math.sin(angle))

export createRandomUnitVector = -> vec2FromRadial (Math.random() * Math.PI * 2), 1

export class Vec2
    (x, y) ->
        @x = x
        @y = y

    toString: -> "(#{@x}, #{@y})"

    add: (v) -> vec2 (@x + v.x), (@y + v.y)
    subtract: (v) -> vec2 (@x - v.x), (@y - v.y)
    dot: (v) -> @x * v.x + @y * v.y
