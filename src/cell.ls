define [
    \tile
    \util
    \vec2
    \direction
    'prelude-ls'
], (Tile,Util, Vec2, Direction, Prelude) ->

    map = Prelude.map

    class Cell
        (@x, @y) ->
            @position = Vec2.Vec2 @x, @y
            @ground = void
            @fixture = void
            @items = []
            @characters = []
            @centre = Vec2.Vec2 (@x+0.5), (@y+0.5)
            @corners = []
            @corners[Direction.OrdinalIndices.NORTHWEST] = Vec2.Vec2 @x, @y
            @corners[Direction.OrdinalIndices.NORTHEAST] = Vec2.Vec2 (@x+1), @y
            @corners[Direction.OrdinalIndices.SOUTHWEST] = Vec2.Vec2 @x, (@y+1)
            @corners[Direction.OrdinalIndices.SOUTHEAST] = Vec2.Vec2 (@x+1), (@y+1)

        setGround: (G) -> 
            @ground = new G this
        setFixture: (F) -> 
            @fixture = new F this

        forEachEffectInGroup: (group, f) ->
            for element in group
                element.forEachEffect f

        forEachEffect: (f) ->
            @ground.forEachEffect f
            @fixture.forEachEffect f
            @forEachEffectInGroup @items
            @forEachEffectInGroup @characters

        _forEachEffect: (f) ->
            for e in effects
                f e

    {
        Cell
    }
