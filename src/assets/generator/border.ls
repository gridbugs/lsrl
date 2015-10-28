define [
    'assets/feature/feature'
    'assets/ground/ground'
    'structures/grid'
], (Feature, Ground, Grid) ->

    class BorderGenerator
        generateGrid: (T, width, height) ->
            grid = new Grid(T, width, height)
            grid.forEach (c) ->
                c.ground = new Ground.Stone()
                c.feature = new Feature.Null()
            grid.forEachBorder (c) ->
                c.feature = new Feature.Wall()

            @grid = grid
            return grid

        getStartingPointHint: -> @grid.get(2, 2)
