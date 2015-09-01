define [
    'types'
    'structures/vec2'
    'structures/direction'
    'util'
], (Types, Vec2, Direction, Util) ->

    class CellSelector
        (@inputSource, @drawer) ->
            @selectedPosition = null

        selectCell: (start_coord, character, game_state, cb, on_each) ->
            @selectedPosition = start_coord
            @selectCellLoop(character, game_state, cb, on_each)

        selectCellLoop: (character, game_state, cb, on_each) ->
            @drawer.drawCellSelectOverlay character, game_state, @selectedPosition
            on_each?(@selectedPosition)
            @inputSource.getControl (control) ~>
                if not control?
                    @selectCellLoop(character, game_state, cb)
                    return

                if control.type == Types.Control.Direction
                    change = Direction.Vectors[control.direction]
                    @selectedPosition = @selectedPosition.add(change)
                    @selectCellLoop(character, game_state, cb, on_each)
                else if control.type == Types.Control.Accept
                    @drawer.drawCharacterKnowledge character, game_state
                    cb @selectedPosition
                else if control.type == Types.Control.Escape
                    @drawer.drawCharacterKnowledge character, game_state
                    cb null
                else
                    @selectCellLoop(character, game_state, cb, on_each)


    {
        CellSelector
    }
