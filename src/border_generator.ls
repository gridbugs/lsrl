define [
    \fixture
    \ground
    \grid
] (Fixture, Ground, Grid) ->

    class BorderGenerator
        generateGrid: (T, width, height) ->
            grid = new Grid.Grid T, width, height
            grid.forEach (c) ->
                c.setGround Ground.Stone
                c.setFixture Fixture.Null
            grid.forEachBorder (c) ->
                c.setFixture Fixture.Wall

            @grid = grid
            return grid

        getStartingPointHint: -> @grid.get(2, 2)

    { BorderGenerator }
