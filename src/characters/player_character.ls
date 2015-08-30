define [
    'characters/knowledge'
    'input/control_interpreter'
    'characters/recursive_shadowcast'
    'characters/omniscient'
    'characters/inventory'
    'types'
    'util'
    'config'
], (Knowledge, ControlInterpreter, Shadowcast, Omniscient, \
    Inventory, Types, Util, Config) ->

    class PlayerCharacter
        (@position, @inputSource, @grid, @ui) ->
            @effects = []
            @knowledge = new Knowledge.Knowledge grid
            @viewDistance = 20

            if Config.OMNISCIENT_PLAYER
                @observe_fn = Omniscient.observe
            else
                @observe_fn = Shadowcast.observe

            @autoMove = null
            @interpreter = new ControlInterpreter.ControlInterpreter this, @inputSource, @ui
            @inventory = new Inventory.Inventory()

            @name = "The player"

        forEachEffect: (f) ->
            for e in @effects
                f e

        canEnterCell: (c) -> not (c.fixture.type == Types.Fixture.Wall)
        getCell: -> @grid.getCart @position
        getKnowledgeCell: -> @knowledge.grid.getCart @position

        getName: -> @name

        canSeeThrough: (cell) ->
            cell.fixture.type != Types.Fixture.Wall

        observe: (game_state) ->
            @observe_fn this, game_state

        getAction: (game_state, cb) ->
            if @autoMove?

                if @inputSource.dirty
                    Util.printDrawer "Key pressed. Cancelling auto move."
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
