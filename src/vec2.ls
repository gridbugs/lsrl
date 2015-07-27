define [], ->
    createFromRadial = (angle, length) -> Vec2 (length * Math.cos(angle)), (length * Math.sin(angle))

    createRandomUnitVector = -> createFromRadial (Math.random() * Math.PI * 2), 1

    class Vec2
        (@x, @y) ~>

        toString: -> "(#{@x}, #{@y})"

        add: (v) -> Vec2 (@x + v.x), (@y + v.y)
        subtract: (v) -> Vec2 (@x - v.x), (@y - v.y)
        dot: (v) -> @x * v.x + @y * v.y
    
    {
        createFromRadial
        createRandomUnitVector
        Vec2
    }
