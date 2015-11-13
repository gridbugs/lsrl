define [
    'system/cell'
    'system/level_state'
    'assets/assets'
    'generation/connection'
    'prelude-ls'
], (Cell, LevelState, Assets, Connection, Prelude) ->

    class Level
        (@gameState) ->
            @levelState = new LevelState(this, @gameState)
            @fromConnections = []
            @toConnections = []

            @id = Level.globalCount
            ++Level.globalCount

            @generated = false

        beforeSwitchTo: ->
            if not @generated
                @generate()

        addConnections: (connections) ->
            @toConnections = @toConnections.concat(connections)

        generate: ->
            @connections = {}
            for k, v of @connectionConstructors
                @connections[k] = v()

            @grid = @generator.generateGrid(Cell, @width, @height, @fromConnections, @toConnections)
            @populate()
            @generated = true

        addPlayerCharacter: (pc) ->
            @addCharacterInitial(pc)
            @gameState.setPlayerCharacter(pc)
            @levelState.setPlayerCharacter(pc)

        addCharacterInitial: (c) ->
            @gameState.registerCharacter(c)
            @addCharacter(c)

        addCharacter: (c) ->
            @grid.getCart(c.position).character = c
            @levelState.registerObserver(c)
            @levelState.scheduleActionSource(c.controller, 0)

        removeCharacter: (c) ->
            @levelState.removeObserverNode(c.observerNode)
            @levelState.purgeActionSource(c.controller)
            @grid.getCart(c.position).character = void

        addDefaultPlayerCharacter: (C = Assets.Character.Human) ->
            pc = new C(@generator.getStartingPointHint().position, @grid, this, Assets.Controller.PlayerController)
            @addPlayerCharacter(pc)

        createChild: (level) ->
            return new Level.Child(this, level)

        getAllConnections: (children) ->
            Prelude.flatten(children.map (c) -> c.connections)

    Level.globalCount = 0

    Level.Child = class
        (@parent, @level) ->
            @connections = []

        createConnections: (n, FromFeature, ToFeature) ->
            for i from 0 til n
                @connections.push(new Connection(
                    @parent, @level, new FromFeature(@level), new ToFeature(@parent)
                ))


    return Level
