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

            for i from 9 til 10
                grid.get(10, i).setFixture(Fixture.Tree)
                grid.get(11, i).setFixture(Fixture.Tree)
                grid.get(12, i).setFixture(Fixture.Tree)
            
            for i from 15 til 20
                grid.get(10, i).setFixture(Fixture.Wall)
                grid.get(11, i).setFixture(Fixture.Wall)
                grid.get(12, i).setFixture(Fixture.Wall)


            grid.forEachBorder (c) ->
                c.setFixture Fixture.Wall

            @grid = grid
            return grid

        getStartingPointHint: -> @grid.get(11, 11)
