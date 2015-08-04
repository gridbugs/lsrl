define [
    \action
    \control
    \knowledge
    \util
], (Action, Control, Knowledge, Util) ->

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

        observe: (game_state) ->
            @knowledge.grid.forEach (c) ~>
                if (@position.distance c.game_cell.position) < 10
                    c.see game_state

    {
        PlayerCharacter
    }
