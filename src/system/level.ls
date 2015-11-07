define [
    'system/cell'
    'common/game_state'
], (Cell, GameState) ->

    class Level
        ->
            @gameState = new GameState()

        generate: ->
            @grid = @generator.generateGrid(Cell, @width, @height)
            @populate()

        addPlayerCharacter: (pc) ->
            @addCharacter(pc)
            @gameState.setPlayerCharacter(pc)

        addCharacter: (c) ->
            @grid.getCart(c.position).character = c
            @gameState.registerObserver(c)
            @gameState.registerCharacter(c)
            @gameState.scheduleActionSource(c.controller, 0)

