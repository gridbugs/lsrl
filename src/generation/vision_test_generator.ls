define [
    'cell/fixture'
    'cell/ground'
    'structures/grid'
], (Fixture, Ground, Grid) ->

    class VisionTestGenerator
        generateGrid: (T, width, height) ->
            grid = new Grid(T, width, height)
            grid.forEach (c) ->
                c.setGround Ground.Stone
                c.setFixture Fixture.Null

            for i from 5 til 10
                grid.get(10, i).setFixture(Fixture.Tree)
                grid.get(11, i).setFixture(Fixture.Tree)
            
            for i from 10 til 15
                grid.get(10, i).setFixture(Fixture.Wall)
                grid.get(11, i).setFixture(Fixture.Wall)


            grid.forEachBorder (c) ->
                c.setFixture Fixture.Wall

            @grid = grid
            return grid

        getStartingPointHint: -> @grid.get(25, 10)
