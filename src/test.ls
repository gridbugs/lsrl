define [
    'prelude-ls'
    \border_generator
    \perlin_test_generator
    \cell_automata_test_generator
    \maze_generator
    \player_character
    \vec2
    \game_state
    \cell
    \fixture
    \user_interface
    \util
    \linked_list
    \binary_tree
    \avl_tree
    \item
    \config
    \types
], (prelude, border_generator, perlin_test_generator, cell_automata_test_generator, MazeGenerator, character, vec2, game_state, cell, Fixture, UserInterface, Util, LinkedList, BinaryTree, AvlTree, Item, Config, Types) ->

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
                else if Math.random() < 0.03
                    if c.fixture.type == Types.Fixture.Null
                        item = new Item.Stone()
                        c.addItem item
                else if Math.random() < 0.03
                    if c.fixture.type == Types.Fixture.Null
                        c.addItem new Item.Plant()



        player = new character.PlayerCharacter (vec2.Vec2 sp.x, sp.y), input_source, grid, new UserInterface.UserInterface(input_source, drawer)

        gs = new game_state.GameState grid, player
        return gs

    linkedListTest = ->
        a = new LinkedList.LinkedList()

        a.insert "hello"
        a.insert "world"

        console.debug a
 
        a.forEachNode (node) ->
            console.debug node

        a.forEach (data) ->
            console.debug data

        x = a.getFirstSatisfyingNode (str) -> str[0] == 'h'
        console.debug x

        a.removeNode x

        console.debug a

        b = new LinkedList.LinkedList()
        for i from 0 to 100
            b.insert i

        console.debug b

        console.debug b.getAllSatisfying (x) -> x % 2
        b.removeAllSatisfying (x) -> x > 50
        console.debug b.getAllSatisfying (x) -> x % 2

    treeTest = (tree) ->
        tree.insert(5, "hello")
        tree.insert(3, "world")
        tree.insert(6, "blah")
        tree.insert(1, "a")
        tree.insert(2, "b")
        tree.insert(4, "c")
        tree.insert(7, "d")
        tree.insert(8, "e")

        tree.forEachPair (k, v) -> console.debug k, v
        console.debug tree
        console.log 'deleting 3'
        tree.deleteByKey(3)
        console.debug tree
        tree.forEachPair (k, v) -> console.debug k, v
        console.log 'deleting and printing 5'
        console.debug(tree.deleteByKey(5))
        tree.forEachPair (k, v) -> console.debug k, v
        
        tree.forEach (v) -> console.debug v
        
        console.debug(tree.findByKey(7))

    avlTreeTest = ->
        a = new BinaryTree.BinaryTree()
        b = new AvlTree.AvlTree()

        console.log "----------- Binary Tree -----------"
        treeTest(a)
        console.log "----------- AVL Tree -----------"
        treeTest(b)



    {
        test
        linkedListTest
        avlTreeTest
    }
