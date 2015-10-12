define [
    'controllers/controller'
    'character/knowledge'
    'interface/control_interpreter'
    'item/inventory'
    'interface/user_interface'
    'types'
    'util'
    'config'
], (Controller, Knowledge, ControlInterpreter, \
    Inventory, UserInterface, Types, Util, Config) ->

    class PlayerController extends Controller
        (@character, @position, @grid) ->
            super()

            @knowledge = new Knowledge(@grid)
            @viewDistance = 20
            @viewDistanceSquared = @viewDistance * @viewDistance

            @autoMove = null
            @interpreter = new ControlInterpreter(@character)
            @inventory = new Inventory()

            @name = "The player"

            @turnCount = -1

        getPosition: ->
            return @character.getPosition()

        getTurnCount: ->
            return @turnCount

        getKnowledge: -> @knowledge
        canEnterCell: (c) -> not (c.fixture.type == Types.Fixture.Wall)
        getCell: -> @character.getCell()
        getKnowledgeCell: -> @knowledge.grid.getCart(@character.getPosition())

        getName: -> @name

        canSeeThrough: (cell) ->
            fixture = cell.fixture
            type = fixture.type
            return type != Types.Fixture.Wall and (type != Types.Fixture.Door || fixture.isOpen()) and type != Types.Fixture.Tree

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
