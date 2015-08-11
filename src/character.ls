define [
    \action
    \control
    \knowledge
    \recursive_shadowcast
    \omniscient
    \types
    \util
    \debug
], (Action, Control, Knowledge, Shadowcast, Omniscient, Types, Util, Debug) ->

    class AutoMove
        (@direction) ->

    class PlayerCharacter
        (@position, @inputSource, @grid) ->
            @effects = []
            @knowledge = new Knowledge.Knowledge grid
            @viewDistance = 20

            if Debug.OMNISCIENT_PLAYER
                @observe_fn = Omniscient.observe
            else
                @observe_fn = Shadowcast.observe

            @autoMode = null

        forEachEffect: (f) ->
            for e in @effects
                f e

        getAction: (game_state, cb) ->
            if @autoMode? and @autoMode.constructor == AutoMove
                if @getCell!.neighbours[@autoMode.direction.index].fixture.type == Types.Fixture.Null
                    cb new Action.Move this, @autoMode.direction, game_state
                    return
                else
                    @autoMode = null

            if @autoMode == null
                @inputSource.getControl (control) ~>
                    if not control?
                        @getAction game_state, cb
                        return

                    a = void
                    if control.type == Control.ControlTypes.DIRECTION
                        a = new Action.Move this, control.direction, game_state
                    else if control.type == Control.ControlTypes.AUTO_DIRECTION
                        a = new Action.Move this, control.direction, game_state
                        @autoMode = new AutoMove control.direction

                    cb a

        getCell: -> @grid.getCart @position

        getName: -> "The player"

        canSeeThrough: (cell) ->
            cell.fixture.type != Types.Fixture.Wall

        observe: (game_state) ->
            @observe_fn this, game_state

    {
        PlayerCharacter
    }
