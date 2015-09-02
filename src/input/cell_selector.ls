define [
    'input/user_interface'
    'structures/vec2'
    'structures/direction'
    'types'
    'util'
], (UserInterface, Vec2, Direction, Types, Util) ->

    class CellSelector
        ->
            @selectedPosition = void

        selectCell: (start_coord, character, game_state, cb, on_each) ->
            @selectedPosition = start_coord
            @selectCellLoop(character, game_state, cb, on_each)

        selectCellLoop: (character, game_state, cb, on_each) ->
            
            UserInterface.drawCellSelectOverlay(character, game_state, @selectedPosition)

            on_each?(@selectedPosition)

            control <~ Util.repeatWhileUndefined(UserInterface.getControl)
            
            if not control?
                return @selectCellLoop(character, game_state, cb, on_each)

            switch control.type
            |   Types.Control.Direction
                    change = Direction.Vectors[control.direction]
                    @selectedPosition = @selectedPosition.add(change)
                    @selectCellLoop(character, game_state, cb, on_each)
            |   Types.Control.Accept
                    UserInterface.drawCharacterKnowledge(character, game_state)
                    cb @selectedPosition
            |   Types.Control.Escape
                    UserInterface.drawCharacterKnowledge(character, game_state)
                    cb(void)
            |   otherwise
                @selectCellLoop(character, game_state, cb, on_each)

    {
        CellSelector
    }
