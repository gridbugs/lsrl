define [
    'prelude-ls'
    'generation/border_generator'
    'generation/cell_automata_test_generator'
    'generation/maze_generator'
    'controllers/player_controller'
    'character/character'
    'structures/vec2'
    'common/game_state'
    'cell/cell'
    'assets/feature/feature'
    'util'
    'structures/linked_list'
    'structures/binary_tree'
    'structures/avl_tree'
    'structures/group_tree'
    'assets/item/item'
    'structures/search'
    'interface/auto_move'
    'interface/user_interface'
    'controllers/null_controller'
    'config'
    'types'
    'controllers/shrubbery_controllers'
    'assets/assets'
    'drawing/tile'
    'front_ends/browser/canvas/drawing/tile'
], (prelude, border_generator, cell_automata_test_generator, MazeGenerator, \
    PlayerController, character, Vec2, GameState, Cell, Feature, Util, LinkedList, BinaryTree, \
    AvlTree, GroupTree, Item, Search, AutoMove, UserInterface, NullController, Config, Types, ShrubberyControllers, \
    Assets, Tile, CanvasTile) ->

    const WIDTH = 80
    const HEIGHT = 30

    test = ->

        drawer = UserInterface.Global.gameDrawer
        input_source = UserInterface.Global.gameController

        if Config.GENERATOR == 'cell_automata'
            c = new cell_automata_test_generator.CellAutomataTestGeneratorRooms()
        else if Config.GENERATOR == 'maze'
            c = new MazeGenerator.MazeGenerator()
        else if Config.GENERATOR == 'border'
            c = new border_generator()
        else if Config.GENERATOR == 'catacombs'
            c = new Assets.Generator.Catacombs()
        else if Config.GENERATOR == 'castle'
            c = new Assets.Generator.Castle()
        else if Config.GENERATOR == 'surface'
            c = new Assets.Generator.Surface()

        grid = c.generateGrid(Cell, WIDTH, HEIGHT)

        if Config.DRAW_MAP_ONLY
            drawer.drawGrid grid
            return

        sp = c.getStartingPointHint()

        pos = new Vec2(sp.x, sp.y)
        char = new Assets.Character.Human(pos, grid, PlayerController)
        drawer.tileScheme.setPlayerCharacter(char)
        drawer.setTileStateData(drawer.tileScheme.createTileStateData(WIDTH, HEIGHT))
        grid.get(sp.x, sp.y).character = char
        gs = new GameState(grid, char.controller)

        characters = [char]

        if Config.GENERATOR == 'cell_automata'
            grid.forEach (c) ->
                if Math.random() < 0.03
                    if c.feature.type == Types.Feature.Null
                        c.feature = new Feature.Web(c)
                else if Math.random() < 0.03
                    if c.feature.type == Types.Feature.Null
                        item = new Item.Stone()
                        c.addItem item
                else if Math.random() < 0.03
                    if c.feature.type == Types.Feature.Null
                        c.addItem new Item.Plant()
                else if Math.random() < 0.01
                    if c.feature.type == Types.Feature.Null
                        c.character = new Assets.Character.Shrubbery(c.position, grid, NullController)
                        characters.push(c.character)
                else if Math.random() < 0.005
                    if c.feature.type == Types.Feature.Null and not c.character?
                        c.character = new Assets.Character.PoisonShrubbery(c.position, grid, ShrubberyControllers.PoisonShrubberyController)
                        gs.scheduleActionSource(c.character.controller, 0)
                        characters.push(c.character)
                else if Math.random() < 0.005
                    if c.feature.type == Types.Feature.Null and not c.character?
                        c.character = new Assets.Character.CarnivorousShrubbery(c.position, grid, ShrubberyControllers.CarnivorousShrubberyController)
                        gs.scheduleActionSource(c.character.controller, 0)
                        characters.push(c.character)

        gs.registerObserver(char)

        for c in characters
            gs.registerCharacter(c)

        return gs

    {
        test
    }
