define [
    'characters/character'
    'characters/knowledge'
    'input/control_interpreter'
    'characters/recursive_shadowcast'
    'characters/omniscient'
    'items/inventory'
    'input/user_interface'
    'types'
    'util'
    'config'
], (Character, Knowledge, ControlInterpreter, Shadowcast, Omniscient, \
    Inventory, UserInterface, Types, Util, Config) ->

    class PlayerCharacter
        (@character, @position, @grid) ->
            @effects = []
            @knowledge = new Knowledge.Knowledge(@grid)
            @viewDistance = 20

            if Config.OMNISCIENT_PLAYER
                @observe_fn = Omniscient.observe
            else
                @observe_fn = Shadowcast.observe

            @autoMove = null
            @interpreter = new ControlInterpreter.ControlInterpreter(@character)
            @inventory = new Inventory.Inventory()

            @name = "The player"

        forEachEffect: (f) ->
            for e in @effects
                f e

        getKnowledge: -> @knowledge
        canEnterCell: (c) -> not (c.fixture.type == Types.Fixture.Wall)
        getCell: -> @character.getCell()
        getKnowledgeCell: -> @knowledge.grid.getCart(@character.getPosition())

        getName: -> @name

        canSeeThrough: (cell) ->
            cell.fixture.type != Types.Fixture.Wall and \
                (cell.fixture.type != Types.Fixture.Door || cell.fixture.isOpen())

        observe: (game_state) ->
            @observe_fn this, game_state

        getAction: (game_state, cb) ->
            if @autoMove?

                if UserInterface.Global.gameController.dirty
                    UserInterface.printLine "Key pressed. Cancelling auto move."
                    @autoMove = null
                else if @autoMove.hasAction!
                    @autoMove.getAction game_state, cb
                    return
                else
                    @autoMove = null

            @interpreter.getAction game_state, cb

        setAutoMove: (autoMove) ->
            if autoMove.canStart()
                @autoMove = autoMove

    {
        PlayerCharacter
    }
