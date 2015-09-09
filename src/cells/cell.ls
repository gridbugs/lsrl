define [
    'structures/vec2'
    'structures/direction'
    'items/inventory'
    'actions/effectable'
    'constants'
    'types'
], (Vec2, Direction, Inventory, Effectable, Constants, Types) ->

    class Cell extends Effectable
        (@x, @y) ->
            @position = Vec2.Vec2 @x, @y
            @character = void
            @ground = void
            @fixture = void
            @items = new Inventory.Inventory()
            @characters = []
            @centre = Vec2.Vec2 (@x+0.5), (@y+0.5)
            @corners = []
            @corners[Types.OrdinalDirection.NorthWest] = Vec2.Vec2 @x, @y
            @corners[Types.OrdinalDirection.NorthEast] = Vec2.Vec2 (@x+1), @y
            @corners[Types.OrdinalDirection.SouthWest] = Vec2.Vec2 @x, (@y+1)
            @corners[Types.OrdinalDirection.SouthEast] = Vec2.Vec2 (@x+1), (@y+1)

            @moveOutCost = 40
            super()

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
            @ground.forEachEffect(f)
            @fixture.forEachEffect(f)
            super(f)

        forEachMatchingEffect: (event_type, f) ->
            @ground.forEachMatchingEffect(event_type, f)
            @fixture.forEachMatchingEffect(event_type, f)
            super(event_type, f)
            
        addItem: (item) ->
            @items.insertItem item

    {
        Cell
    }
