define [
    \action
    \auto_move
    \types
    \util
], (Action, AutoMove, Types, Util) ->
    
    class ControlInterpreter
        (@character, @inputSource) ->


        getAction: (game_state, cb) ->
            Util.repeatWhileUndefined @inputSource.getControl, (control) ~>
                
                action = switch control.type
                |   Types.Control.Direction
                        new Action.Move @character, control.direction, game_state

                if action?
                    cb action
                    return

                # If we get this far, the player attempted an auto move
                auto_move = switch control.type
                |   Types.Control.AutoDirection
                        new AutoMove.StraightLineMove @character, control.direction
                |   Types.Control.AutoExplore
                        new AutoMove.AutoExplore @character

                if auto_move?
                    @character.setAutoMove auto_move
                    @character.getAction game_state, cb
                    return
                
                @getAction game_state, cb

    {
        ControlInterpreter
    }
