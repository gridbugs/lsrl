define [
    \action
    \control
    \knowledge
    \recursive_shadowcast
    \util
], (Action, Control, Knowledge, Shadowcast, Util) ->

    class PlayerCharacter
        (@position, @inputSource, @grid) ->
            @effects = []
            @knowledge = new Knowledge.Knowledge grid

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
            Shadowcast.observe this, game_state

    {
        PlayerCharacter
    }
