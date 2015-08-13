define ['prelude-ls', \border_generator, \perlin_test_generator, \cell_automata_test_generator, \maze_generator, \character, \vec2, \game_state, \cell, \fixture, \util, \debug, \types], \
    (prelude, border_generator, perlin_test_generator, cell_automata_test_generator, MazeGenerator, character, vec2, game_state, cell, Fixture, Util, Debug, Types) ->

    test = (drawer, input_source) ->
        c = new cell_automata_test_generator.CellAutomataTestGenerator!
        #c = new MazeGenerator.MazeGenerator!
        #c = new border_generator.BorderGenerator!
        grid = c.generateGrid cell.Cell, 80, 30

        if Debug.DRAW_MAP_ONLY
            drawer.drawGrid grid
            return

        sp = c.getStartingPointHint!

        grid.forEach (c) ->
            if Math.random() < 0.03
                if c.fixture.type == Types.Fixture.Null
                    c.setFixture Fixture.Web

        player = new character.PlayerCharacter (vec2.Vec2 sp.x, sp.y), input_source, grid

        gs = new game_state.GameState grid, player
        return gs

    { test }
