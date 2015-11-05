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
