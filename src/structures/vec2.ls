define [], ->

    class Vec2
        (@x, @y) ->

        arraySet: (idx, val) !->
            switch idx
            |   0 => @x = val
            |   _ => @y = val

        arrayGet: (idx) !->
            switch idx
            |   0 => return @x
            |   _ => return @y

        toString: -> "(#{@x}, #{@y})"

        add: (v) -> new Vec2((@x + v.x), (@y + v.y))
        subtract: (v) -> new Vec2((@x - v.x), (@y - v.y))
        multiply: (s) -> new Vec2((@x * s), (@y * s))
        divide: (s) -> new Vec2((@x / s), (@y / s))
        dot: (v) -> @x * v.x + @y * v.y
        length: -> Math.sqrt @dot(this)

        distanceSquared: (v) ->
            dx = @x - v.x
            dy = @y - v.y
            return dx*dx+dy*dy

        distance: (v) ->
            dx = @x - v.x
            dy = @y - v.y
            return Math.sqrt(dx*dx+dy*dy)

        equals: (v) -> @x == v.x and @y == v.y

    Vec2.X_IDX = 0
    Vec2.Y_IDX = 1
    Vec2.otherIndex = (index) -> 1 - index
    Vec2.createFromRadial = (angle, length) ->
        return new Vec2((length * Math.cos(angle)), (length * Math.sin(angle)))
    Vec2.createRandomUnitVector = ->
        return createFromRadial((Math.random() * Math.PI * 2), 1)

    return Vec2
