define [
    'interface/input'
    'interface/key'
    'interface/mouse_event'
    'structures/vec2'
], (InputSource, Key, MouseEvent, Vec2) ->

    class BrowserInputSource extends InputSource
        ->
            super()

            $(window).keydown (e) ~>
                if @currentCallback?
                    callback = @currentCallback
                    @currentCallback = null

                    key = new Key(
                        String.fromCharCode(e.keyCode),
                        e.keyCode,
                        e.shiftKey,
                        e.ctrlKey,
                        e.metaKey
                    )

                    callback(key)
                else
                    @dirty = true

            $(window).mousedown (e) ~>
                if @acceptMouse and @currentCallback?
                    coord = @coordFromMouseEvent(e)
                    if coord.x >= @drawer.numCols or coord.y >= @drawer.numRows
                        return

                    callback = @currentCallback
                    @currentCallback = null

                    event = new MouseEvent(true, true, coord)
                    callback(event)
                else
                    @dirty = true

            $(window).mousemove (e) ~>
                if @acceptMouse
                    coord = @coordFromMouseEvent(e)
                    if coord.x >= @drawer.numCols or coord.y >= @drawer.numRows
                        @drawer.drawCharacterKnowledge(@character)
                    else
                        @drawer.drawCellSelectOverlay(@character, @gameState, coord)

        coordFromMouseEvent: (e) ->
            x = parseInt(e.clientX / @drawer.cellWidth)
            y = parseInt(e.clientY / @drawer.cellHeight)
            return new Vec2(x, y)

        setDrawer: (@drawer) ->
        setCharacter: (@character) ->
        setGameState: (@gameState) ->
