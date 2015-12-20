define [
    'system/controller'
    'system/knowledge'
    'interface/control_interpreter'
    'system/flat_inventory'
    'interface/user_interface'
    'types'
    'util'
    'config'
    'asset_system'
], (Controller, Knowledge, ControlInterpreter, \
    FlatInventory, UserInterface, Types, Util, Config, AssetSystem) ->

    class PlayerController extends Controller
        (@character, @position, @grid) ->
            super(@grid)

            @viewDistance = 20
            @viewDistanceSquared = @viewDistance * @viewDistance

            @autoMove = null
            @interpreter = new ControlInterpreter(@character)
            @inventory = new FlatInventory(Config.INVENTORY_SLOTS)

            @name = "The player"

            @turnCount = -1

        getPosition: ->
            return @character.getPosition()

        getTurnCount: ->
            return @turnCount

        getKnowledge: -> @knowledge

        getName: -> @name


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

    AssetSystem.exposeAsset('Controller', PlayerController)
