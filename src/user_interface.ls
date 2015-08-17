define [
    \types
    \vec2
    \direction
    \util
], (Types, Vec2, Direction, Util) ->
    
    class UserInterface
        (@inputSource, @drawer) ->
            @selectedPosition = null

        selectCell: (start_coord, character, game_state, cb) ->
            @selectedPosition = start_coord
            @selectCellLoop(character, game_state, cb)
            
        selectCellLoop: (character, game_state, cb) ->
            @drawer.drawCellSelectOverlay character, game_state, @selectedPosition
            @inputSource.getControl (control) ~>
                if not control?
                    @selectCellLoop(character, game_state, cb)
                    return
                    
                if control.type == Types.Control.Direction
                    change = Direction.Vectors[control.direction]
                    @selectedPosition = @selectedPosition.add(change)
                    @selectCellLoop(character, game_state, cb)
                else if control.type == Types.Control.Accept
                    cb @selectedPosition
                else if control.type == Types.Control.Escape
                    @drawer.drawCharacterKnowledge character, game_state
                    cb null
                else
                    @selectCellLoop(character, game_state, cb)


    {
        UserInterface
    }
