define [], ->
    createFromRadial = (angle, length) -> Vec2 (length * Math.cos(angle)), (length * Math.sin(angle))

    createRandomUnitVector = -> createFromRadial (Math.random() * Math.PI * 2), 1

    class Vec2
        (@x, @y) ~>

        arraySet: (idx, val) -> [(~> @x = val), (~> @y = val)][idx]()
        arrayGet: (idx) -> [@x, @y][idx]
        toString: -> "(#{@x}, #{@y})"

        add: (v) -> Vec2 (@x + v.x), (@y + v.y)
        subtract: (v) -> Vec2 (@x - v.x), (@y - v.y)
        multiply: (s) -> Vec2 (@x * s), (@y * s)
        divide: (s) -> Vec2 (@x / s), (@y / s)
        dot: (v) -> @x * v.x + @y * v.y
        length: -> Math.sqrt @dot(this)
        distance: (v) -> (@subtract v).length!
        equals: (v) -> @x == v.x and @y == v.y
    X_IDX = 0
    Y_IDX = 1
    otherIndex = (index) -> 1 - index

    {
        createFromRadial
        createRandomUnitVector
        Vec2
        X_IDX
        Y_IDX
        otherIndex
    }
