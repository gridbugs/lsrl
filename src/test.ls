define ['prelude-ls', \perlin_test_generator, \cell_automata_test_generator, \character, \vec2, \game_state, \cell], \
    (prelude, perlin_test_generator, cell_automata_test_generator, character, vec2, game_state, cell) ->

    test = (drawer, input_source) ->
        c = new cell_automata_test_generator.CellAutomataTestGenerator!
        grid = c.generateGrid cell.Cell, 120, 40
        sp = c.getStartingPointHint!
        /*
        grid.forEach (c) ->
            if Math.random() < 0.01
                c.become cell.spiderWebPrototype!
        */
        player = new character.PlayerCharacter (vec2.Vec2 sp.x, sp.y), input_source

        gs = new game_state.GameState grid, player
        return gs

    { test }
