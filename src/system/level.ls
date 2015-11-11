define [
    'system/cell'
    'common/game_state'
    'assets/assets'
    'generation/connection'
    'prelude-ls'
], (Cell, GameState, Assets, Connection, Prelude) ->

    class Level
        ->
            @gameState = new GameState()
            @fromConnections = []
            @toConnections = []

        addConnections: (connections) ->
            @toConnections = @toConnections.concat(connections)

        generate: ->
            @connections = {}
            for k, v of @connectionConstructors
                @connections[k] = v()

            @grid = @generator.generateGrid(Cell, @width, @height, @fromConnections, @toConnections)
            @populate()

        

        addPlayerCharacter: (pc) ->
            @addCharacter(pc)
            @gameState.setPlayerCharacter(pc)

        addCharacter: (c) ->
            @grid.getCart(c.position).character = c
            @gameState.registerObserver(c)
            @gameState.registerCharacter(c)
            @gameState.scheduleActionSource(c.controller, 0)

        addDefaultPlayerCharacter: (C = Assets.Character.Human) ->
            pc = new C(@generator.getStartingPointHint().position, @grid, Assets.Controller.PlayerController)
            @addPlayerCharacter(pc)
            @gameState.setDescriptionProfile(new Assets.DescriptionProfile.Default(pc))

        createChild: (level) ->
            return new Level.Child(this, level)

        getAllConnections: (children) ->
            Prelude.flatten(children.map (c) -> c.connections)
            

    Level.Child = class
        (@parent, @level) ->
            @connections = []

        createConnections: (n, FromFeature, ToFeature) ->
            for i from 0 til n
                @connections.push(new Connection(
                    @parent, @level, new FromFeature(@level), new ToFeature(@parent)
                ))
                

    return Level
