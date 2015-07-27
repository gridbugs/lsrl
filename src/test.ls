define ['prelude-ls', \perlin_test_generator, \cell_automata_test_generator, \character, \vec2, \game_state], \
    (prelude, perlin_test_generator, cell_automata_test_generator, character, vec2, game_state) ->

    class Cell
        (@x, @y) ->
        toString: -> "(#{@x} #{@y})"

    test = (drawer, input_source) ->
        c = new cell_automata_test_generator.CellAutomataTestGenerator!
        grid = c.generateGrid Cell, 120, 40
        sp = c.getStartingPointHint!
        
        console.log character.PlayerCharacter
        player = new character.PlayerCharacter (vec2.Vec2 sp.x, sp.y), input_source

        gs = new game_state.GameState grid, player
        return gs
    
    { test }
