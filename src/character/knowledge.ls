define [
    'structures/grid'
], (Grid) ->

    class KnowledgeCell
        (@x, @y) ->
            @gameCell = null
            @known = false
            @timestamp = -1
            @ground = void
            @fixture = void
            @items = void
            @character = void

        init: (game_cell) ->
            @gameCell = game_cell
            @ground = @gameCell.ground
            @fixture = @gameCell.fixture
            @position = @gameCell.position
            @items = @gameCell.items
            @character = @gameCell.character

        see: (game_state) ->
            @known = true
            @timestamp = game_state.getTurnCount()
            @ground = @gameCell.ground
            @fixture = @gameCell.fixture

            @character = @gameCell.character

        hasUnknownNeighbour: ->
            for n in @allNeighbours
                if not n.known
                    return true
            return false

    class Knowledge
        (grid) ->
            @grid = new Grid(KnowledgeCell, grid.width, grid.height)
            for i from 0 til grid.height
                for j from 0 til grid.width
                    @grid.get(j, i).init grid.get(j, i)
