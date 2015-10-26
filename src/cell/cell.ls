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

    class Cell implements Visitable, Neighbourable
        (@x, @y) ->
            @position = new Vec2(@x, @y)
            @character = void
            @ground = void
            @feature = void
            @items = new Inventory()
            @characters = []
            @centre = new Vec2 (@x+0.5), (@y+0.5)
            @corners = []
            @corners[Types.OrdinalDirection.NorthWest] = new Vec2(@x, @y)
            @corners[Types.OrdinalDirection.NorthEast] = new Vec2((@x+1), @y)
            @corners[Types.OrdinalDirection.SouthWest] = new Vec2(@x, (@y+1))
            @corners[Types.OrdinalDirection.SouthEast] = new Vec2((@x+1), (@y+1))

            @moveOutCost = 40

        notify: (action, relationship, game_state) ->
            @feature.notify(action, relationship, game_state)

        getMoveOutCost: (direction) ->
            if Direction.isCardinal direction
                return @moveOutCost
            else
                return @moveOutCost * Constants.SQRT2

        addItem: (item) ->
            @items.insertItem item

        countNeighboursSatisfying: (predicate) ->
            count = 0
            for n in @allNeighbours
                if predicate(n)
                    ++count
            return count
