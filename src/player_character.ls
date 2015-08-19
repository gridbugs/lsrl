define [
    \knowledge
    \control_interpreter
    \recursive_shadowcast
    \omniscient
    \types
    \util
    \config
], (Knowledge, ControlInterpreter, Shadowcast, Omniscient, Types, Util, Config) ->

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
