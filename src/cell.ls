define [
    \tile
    \util
    \vec2
    \direction
    \item_collection
    \unique_list
    \linked_list
    \constants
    \types
    'prelude-ls'
], (Tile,Util, Vec2, Direction, ItemCollection, UniqueList, LinkedList, Constants, Types, Prelude) ->

    map = Prelude.map


    class Cell
        (@x, @y) ->
            @position = Vec2.Vec2 @x, @y
            @ground = void
            @fixture = void
            @items = new ItemCollection.ItemCollection()
            @characters = []
            @centre = Vec2.Vec2 (@x+0.5), (@y+0.5)
            @corners = []
            @corners[Types.OrdinalDirection.NorthWest] = Vec2.Vec2 @x, @y
            @corners[Types.OrdinalDirection.NorthEast] = Vec2.Vec2 (@x+1), @y
            @corners[Types.OrdinalDirection.SouthWest] = Vec2.Vec2 @x, (@y+1)
            @corners[Types.OrdinalDirection.SouthEast] = Vec2.Vec2 (@x+1), (@y+1)

            @moveOutCost = 40

        getMoveOutCost: (direction) ->
            if Direction.isCardinal direction
                return @moveOutCost
            else
                return @moveOutCost * Constants.SQRT2

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
            @forEachEffectInGroup @characters

        _forEachEffect: (f) ->
            for e in effects
                f e

        addItem: (item) ->
            @items.insertItem item

    {
        Cell
    }
