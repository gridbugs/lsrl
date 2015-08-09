define [
    \action
    \control
    \knowledge
    \recursive_shadowcast
    \omniscient
    \util
    \debug
], (Action, Control, Knowledge, Shadowcast, Omniscient, Util, Debug) ->

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
            @effects.forEach f

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

        canSeeThrough: (cell) -> cell.fixture.constructor.name != 'Wall'

        observe: (game_state) ->
            @observe_fn this, game_state

    {
        PlayerCharacter
    }
