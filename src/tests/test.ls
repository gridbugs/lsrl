define [
    'prelude-ls'
    'generation/border_generator'
    'generation/perlin_test_generator'
    'generation/cell_automata_test_generator'
    'generation/maze_generator'
    'characters/player_character'
    'characters/character'
    'structures/vec2'
    'common/game_state'
    'cells/cell'
    'cells/fixture'
    'input/cell_selector'
    'util'
    'structures/linked_list'
    'structures/binary_tree'
    'structures/avl_tree'
    'structures/group_tree'
    'items/item'
    'structures/search'
    'input/auto_move'
    'input/user_interface'
    'characters/null_controller'
    'config'
    'types'
    'controllers/shrubbery_controllers'
    'actions/effect'
], (prelude, border_generator, perlin_test_generator, cell_automata_test_generator, MazeGenerator, \
    pcharacter, character, Vec2, GameState, Cell, Fixture, CellSelector, Util, LinkedList, BinaryTree, \
    AvlTree, GroupTree, Item, Search, AutoMove, UserInterface, NullController, Config, Types, ShrubberyControllers, \
    Effect) ->

    test = ->
        drawer = UserInterface.Global.gameDrawer
        input_source = UserInterface.Global.gameController

        if Config.GENERATOR == 'cell_automata'
            c = new cell_automata_test_generator.CellAutomataTestGeneratorRooms()
        else if Config.GENERATOR == 'maze'
            c = new MazeGenerator.MazeGenerator()
        else if Config.GENERATOR == 'border'
            c = new border_generator.BorderGenerator()

        grid = c.generateGrid Cell, 80, 30

        if Config.DRAW_MAP_ONLY
            drawer.drawGrid grid
            return

        sp = c.getStartingPointHint()

        pos = new Vec2(sp.x, sp.y)
        char = new character.Human(pos, grid, pcharacter.PlayerCharacter)
        char.setAsPlayerCharacter()
        grid.get(sp.x, sp.y).character = char
        gs = new GameState(grid, char.controller)

        if Config.GENERATOR == 'cell_automata'
            grid.forEach (c) ->
                if Math.random() < 0.03
                    if c.fixture.type == Types.Fixture.Null
                        c.setFixture Fixture.Web
                else if Math.random() < 0.03
                    if c.fixture.type == Types.Fixture.Null
                        item = new Item.Stone()
                        c.addItem item
                else if Math.random() < 0.03
                    if c.fixture.type == Types.Fixture.Null
                        c.addItem new Item.Plant()
                else if Math.random() < 0.01
                    if c.fixture.type == Types.Fixture.Null
                        c.character = new character.Shrubbery(c.position, grid, NullController.NullController)
                else if Math.random() < 0.005
                    if c.fixture.type == Types.Fixture.Null and not c.character?
                        c.character = new character.PoisonShrubbery(c.position, grid, ShrubberyControllers.PoisonShrubberyController)
                        gs.scheduleActionSource(c.character.controller, 0)
                else if Math.random() < 0.005
                    if c.fixture.type == Types.Fixture.Null and not c.character?
                        c.character = new character.CarnivorousShrubbery(c.position, grid, ShrubberyControllers.CarnivorousShrubberyController)
                        gs.scheduleActionSource(c.character.controller, 0)

        gs.registerObserver(char)
        char.addEffect(new Effect.ResurrectOnDeath())

        return gs

    {
        test
    }
