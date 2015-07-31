define [
    \newaction
    \direction
    \util
    \control
], (Action, direction, util, control) ->


    class PlayerCharacter
        (@position, @inputSource) ->
            @effects = []
        getAction: (game_state, cb) ->
            @inputSource.getControl (ctrl) ~>
                if not ctrl?
                    @getAction game_state, cb
                    return

                a = void
                if ctrl.type == control.ControlTypes.DIRECTION
                    a = new Action.Move this, ctrl.direction, game_state

                cb a
    {
        PlayerCharacter
    }
