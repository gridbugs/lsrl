define [
    'structures/grid'
], (Grid) ->

    class KnowledgeCell
        (@x, @y) ->
            @game_cell = null
            @known = false
            @timestamp = 0
            @ground = void
            @fixture = void
            @items = void
            @character = void

        init: (game_cell) ->
            @game_cell = game_cell
            @ground = @game_cell.ground
            @fixture = @game_cell.fixture
            @position = @game_cell.position
            @items = @game_cell.items
            @character = @game_cell.character

        see: (game_state) ->
            @known = true
            @timestamp = game_state.getTurnCount()
            @ground = @game_cell.ground
            @fixture = @game_cell.fixture
            @character = @game_cell.character

        hasUnknownNeighbour: ->
            for n in @allNeighbours
                if not n.known
                    return true
            return false

    class Knowledge
        (grid) ->
            @grid = new Grid.Grid KnowledgeCell, grid.width, grid.height
            for i from 0 til grid.height
                for j from 0 til grid.width
                    @grid.get(j, i).init grid.get(j, i)

    {
        Knowledge
    }
