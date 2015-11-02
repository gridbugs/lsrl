define [
    'prelude-ls'
    'assets/generator/border'
    'assets/generator/cave'
    'assets/generator/maze'
    'assets/controller/player_controller'
    'system/character'
    'structures/vec2'
    'common/game_state'
    'system/cell'
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
    'assets/controller/null_controller'
    'config'
    'types'
    'assets/controller/shrubbery_controllers'
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

        if Config.GENERATOR == 'cave'
            c = new cell_automata_test_generator.Rooms()
        else if Config.GENERATOR == 'maze'
            c = new MazeGenerator()
        else if Config.GENERATOR == 'border'
            c = new border_generator()
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
        gs = new GameState(grid, char.controller, new Assets.DescriptionProfile.Default(char))
        Assets.Describer.English.installPlayerCharacter(char)
        characters = [char]

        if Config.GENERATOR == 'cave'
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
                        characters.push(c.character)
                else if Math.random() < 0.005
                    if c.feature.type == Types.Feature.Null and not c.character?
                        c.character = new Assets.Character.CarnivorousShrubbery(c.position, grid, ShrubberyControllers.CarnivorousShrubberyController)
                        characters.push(c.character)
        else if Config.GENERATOR == 'surface'
            grid.forEach (c) ->
                if c.feature.type == Types.Feature.Null and Math.random() < 0.01
                    s = new Assets.Character.Spider(c.position, grid, Assets.Controller.SpiderController)
                    c.character = s
                    c.feature = new Assets.Feature.Web(c)
                    characters.push(s)

        for c in characters
            gs.registerObserver(c)
            gs.registerCharacter(c)
            gs.scheduleActionSource(c.controller, 0)

        return gs

    {
        test
    }
