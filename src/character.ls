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

    class PlayerCharacter
        (@position, @inputSource, @grid) ->
            @effects = []
            @knowledge = new Knowledge.Knowledge grid
            @viewDistance = 20

            if Debug.OMNISCIENT_PLAYER
                @observe_fn = Omniscient.observe
            else
                @observe_fn = Shadowcast.observe

        forEachEffect: (f) ->
            for e in @effects
                f e

        getAction: (game_state, cb) ->
            @inputSource.getControl (control) ~>
                if not control?
                    @getAction game_state, cb
                    return

                a = void
                if control.type == Control.ControlTypes.DIRECTION
                    a = new Action.Move this, control.direction, game_state

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
