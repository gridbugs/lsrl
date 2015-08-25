define [
    \knowledge
    \control_interpreter
    \recursive_shadowcast
    \omniscient
    \alphabetic_list
    \unique_list
    \bucket_list
    \linked_list
    \inventory
    \types
    \util
    \config
], (Knowledge, ControlInterpreter, Shadowcast, Omniscient, \
    AlphabeticList, UniqueList, BucketList, LinkedList, Inventory, \
    Types, Util, Config) ->

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

            @inventoryAlphabet = new AlphabeticList.AlphabeticList(
                new LinkedList.LinkedList()
            )

            @inventory = new Inventory.Inventory()

        addItemToInventory: (item) ->
            return @inventory.insertItem(item)

        removeItemFromInventory: (item) ->
            return @inventory.removeItem(item)

        forEachEffect: (f) ->
            for e in @effects
                f e

        canEnterCell: (c) -> not (c.fixture.type == Types.Fixture.Wall)
        getCell: -> @grid.getCart @position
        getKnowledgeCell: -> @knowledge.grid.getCart @position

        getName: -> "The player"

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
