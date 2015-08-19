define [
    \action
    \auto_move
    \types
    \search
    \util
], (Action, AutoMove, Types, Search, Util) ->
    
    class ControlInterpreter
        (@character, @inputSource, @ui) ->


        getAction: (game_state, cb) ->
            Util.repeatWhileUndefined @inputSource.getControl, (control) ~>
                
                switch control.type
                |   Types.Control.Direction
                        return cb new Action.Move @character, control.direction, game_state
                |   Types.Control.AutoDirection
                        @character.setAutoMove(
                            new AutoMove.StraightLineMove @character, control.direction
                        )
                        @character.getAction game_state, cb
                |   Types.Control.AutoExplore
                        @character.setAutoMove(
                            new AutoMove.AutoExplore @character
                        )
                        @character.getAction game_state, cb
                |   Types.Control.NavigateToCell
                        @navigateToCell(@character.position, game_state, cb)
                        
                

        navigateToCell: (start_coord, game_state, cb) ->
            @ui.selectCell start_coord, @character, game_state, (coord) ~>
                if not coord?
                    return

                dest_cell = @character.grid.getCart coord

                result = Search.findPath @character.getKnowledgeCell(), \
                    ((c, d) -> c.game_cell.getMoveOutCost d), \
                    ((c) -> c.known and c.fixture.type == Types.Fixture.Null), \
                    dest_cell
                
                if result?
                    @character.setAutoMove(new AutoMove.FollowPath(@character, result.directions))
                    @character.getAction game_state, cb
                else
                    Util.printDrawer "Can't reach selected cell."
                    @navigateToCell coord, game_state, cb

    {
        ControlInterpreter
    }
