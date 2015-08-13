define [
    'prelude-ls'
    \border_generator
    \perlin_test_generator
    \cell_automata_test_generator
    \maze_generator
    \character
    \vec2
    \game_state
    \cell
    \fixture
    \util
    \config
    \types
], (prelude, border_generator, perlin_test_generator, cell_automata_test_generator, MazeGenerator, character, vec2, game_state, cell, Fixture, Util, Config, Types) ->

    test = (drawer, input_source) ->
        if Config.GENERATOR == 'cell_automata'
            c = new cell_automata_test_generator.CellAutomataTestGenerator!
        else if Config.GENERATOR == 'maze'
            c = new MazeGenerator.MazeGenerator!
        else if Config.GENERATOR == 'border'
            c = new border_generator.BorderGenerator!

        grid = c.generateGrid cell.Cell, 80, 30

        if Config.DRAW_MAP_ONLY
            drawer.drawGrid grid
            return

        sp = c.getStartingPointHint!

        if Config.GENERATOR == 'cell_automata'
            grid.forEach (c) ->
                if Math.random() < 0.03
                    if c.fixture.type == Types.Fixture.Null
                        c.setFixture Fixture.Web

        player = new character.PlayerCharacter (vec2.Vec2 sp.x, sp.y), input_source, grid

        gs = new game_state.GameState grid, player
        return gs

    { test }
