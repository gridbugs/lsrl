define [
    'structures/vec2'
    'structures/direction'
    'structures/visitable'
    'structures/neighbourable'
    'item/inventory'
    'action/effectable'
    'constants'
    'types'
], (Vec2, Direction, Visitable, Neighbourable, Inventory, Effectable, Constants, Types) ->

    class Cell extends Effectable implements Visitable, Neighbourable
        (@x, @y) ->
            @position = new Vec2(@x, @y)
            @character = void
            @ground = void
            @fixture = void
            @items = new Inventory()
            @characters = []
            @centre = new Vec2 (@x+0.5), (@y+0.5)
            @corners = []
            @corners[Types.OrdinalDirection.NorthWest] = new Vec2(@x, @y)
            @corners[Types.OrdinalDirection.NorthEast] = new Vec2((@x+1), @y)
            @corners[Types.OrdinalDirection.SouthWest] = new Vec2(@x, (@y+1))
            @corners[Types.OrdinalDirection.SouthEast] = new Vec2((@x+1), (@y+1))

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
            @character?.forEachMatchingEffect(event_type, f)
            super(event_type, f)

        addItem: (item) ->
            @items.insertItem item

        isEmpty: ->
            return (@fixture.type == Types.Fixture.Null or @fixture.type == Types.Fixture.Bridge) and (not @character?) and
                (@fixture.type != Types.Fixture.Door || @fixture.isOpen())

        countNeighboursSatisfying: (predicate) ->
            count = 0
            for n in @allNeighbours
                if predicate(n)
                    ++count
            return count
