define ['prelude-ls', \perlin_test_generator, \cell_automata_test_generator, \character, \vec2, \game_state, \cell, \fixture, \util], \
    (prelude, perlin_test_generator, cell_automata_test_generator, character, vec2, game_state, cell, Fixture, Util) ->

    test = (drawer, input_source) ->
        c = new cell_automata_test_generator.CellAutomataTestGenerator!
        grid = c.generateGrid cell.Cell, 120, 40
        sp = c.getStartingPointHint!
        
        grid.forEach (c) ->
            if Math.random() < 0.01
                c.setFixture Fixture.Web
        
        for i from 0 til grid.width
            grid.get(i, grid.height-1).setFixture Fixture.Web

        #player = new character.PlayerCharacter (vec2.Vec2 sp.x, sp.y), input_source, grid
        player = new character.PlayerCharacter (vec2.Vec2 60, 19), input_source, grid

        gs = new game_state.GameState grid, player
        return gs

    { test }
