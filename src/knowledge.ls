define [
    \cell
    \grid
    'prelude-ls'
], (Cell, Grid, Prelude) ->
 
    map = Prelude.map
    id = Prelude.id

    class KnowledgeCell
        (@x, @y) ->
            @game_cell = null
            @known = false
            @timestamp = 0
            @ground = null
            @fixture = null

        init: (game_cell) ->
            @game_cell = game_cell

        see: (game_state) ->
            @ground = @game_cell.ground
            @fixture = @game_cell.fixture
            @known = true
            @timestamp = game_state.absoluteTime

    class Knowledge
        (grid) ->
            @grid = new Grid.Grid KnowledgeCell, grid.width, grid.height
            for i from 0 til grid.height
                for j from 0 til grid.width
                    @grid.get(j, i).init grid.get(j, i)

    {
        Knowledge
    }
