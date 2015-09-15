define [
    'controllers/controller'
    'character/knowledge'
    'interface/control_interpreter'
    'character/recursive_shadowcast'
    'character/omniscient'
    'item/inventory'
    'interface/user_interface'
    'types'
    'util'
    'config'
], (Controller, Knowledge, ControlInterpreter, Shadowcast, Omniscient, \
    Inventory, UserInterface, Types, Util, Config) ->

    class PlayerController extends Controller
        (@character, @position, @grid) ->
            super()

            @knowledge = new Knowledge(@grid)
            @viewDistance = 20

            if Config.OMNISCIENT_PLAYER
                @observe_fn = Omniscient.observe
            else
                @observe_fn = Shadowcast.observe

            @autoMove = null
            @interpreter = new ControlInterpreter(@character)
            @inventory = new Inventory()

            @name = "The player"

            @turnCount = -1

        getTurnCount: ->
            return @turnCount

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
            @turnCount = game_state.getTurnCount()

        getAction: (game_state, cb) ->

            if @autoMove?

                if UserInterface.Global.gameController.dirty
                    UserInterface.printLine "Key pressed. Cancelling auto move."
                    @autoMove = null
                else if @autoMove.hasAction()
                    @autoMove.getAction(game_state, cb)
                    return
                else
                    @autoMove = null

            @interpreter.getAction game_state, cb

        setAutoMove: (autoMove) ->
            if autoMove.canStart()
                @autoMove = autoMove

        clearAutoMove: ->
            @autoMove = void
