define [
    'structures/grid'
], (Grid) ->

    class KnowledgeCell
        (@x, @y) ->
            @gameCell = null
            @known = false
            @timestamp = -1
            @ground = void
            @feature = void
            @items = void
            @character = void

        init: (game_cell, @knowledge) ->
            @gameCell = game_cell
            @ground = @gameCell.ground
            @feature = @gameCell.feature
            @position = @gameCell.position
            @items = @gameCell.items
            @character = @gameCell.character

        see: (game_state) ->
            @known = true
            @timestamp = game_state.getTurnCount()
            @ground = @gameCell.ground
            @feature = @gameCell.feature

            @character = @gameCell.character

            if @character? and @character != @knowledge.character
                @knowledge.visibleCharacters.push(@character)

        hasUnknownNeighbour: ->
            for n in @allNeighbours
                if not n.known
                    return true
            return false

    class Knowledge
        (grid, @controller) ->
            @grid = new Grid(KnowledgeCell, grid.width, grid.height)
            for i from 0 til grid.height
                for j from 0 til grid.width
                    @grid.get(j, i).init(grid.get(j, i), this)

            @character = @controller.character
            @visibleCharacters = []

        beforeObserve: ->
            @visibleCharacters = []

        afterObserve: ->

    Knowledge.KnowledgeCell = KnowledgeCell

    return Knowledge
