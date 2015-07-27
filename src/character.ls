define [\action, \direction, \util, \control], \
    (action, direction, util, control) ->


    class PlayerCharacter
        (@position, @inputSource) ->

        getAction: (game_state, cb) ->
            @inputSource.getControl (ctrl) ~>
                if not ctrl?
                    cb new action.NullAction this, game_state
                    return

                a = void
                if ctrl.type == control.ControlTypes.DIRECTION
                    a = new action.MoveAction this, ctrl.direction, game_state

                if a?
                    cb a
                else
                    cb new action.NullAction this, game_state
    {
        PlayerCharacter
    }
