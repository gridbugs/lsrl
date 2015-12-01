define [
    'front_ends/console/input'
    'interface/key'
    'structures/vec2'
    'interface/mouse_event'
], (BaseInput, Key, Vec2, MouseEvent) ->

    const ENTER_KEY = 13

    NameToCode = {
        left: Key.LEFT
        right: Key.RIGHT
        up: Key.UP
        down: Key.DOWN
        escape: Key.ESCAPE
        return: Key.ENTER
        ';': Key.SEMICOLON
        ':': Key.COLON
    }

    class Input extends BaseInput
        (@program) ->
            super()

            @program.on 'keypress', (c, obj) ~>

                if obj.name == 'enter'
                    return

                code = NameToCode[obj.name]
                if not code?
                    if obj.name?
                        code = obj.name.toUpperCase().charCodeAt(0)

                key = new Key(
                    obj.name,
                    code,
                    obj.shift,
                    obj.ctrl,
                    obj.meta
                )

                @handleInputKey(key)

            @program.on 'mouse', (e) ~>
                if @acceptMouse
                    if e.action == 'mousedown' and @prev?.action != 'mousedown'
                        if @currentCallback?
                            coord = @coordFromMouseEvent(e)

                            if coord.x >= @drawer.width or coord.y >= @drawer.height
                                return
                            
                            callback = @currentCallback
                            @currentCallback = null

                            event = new MouseEvent(true, true, coord)
                            callback(event)
                    else
                        coord = @coordFromMouseEvent(e)
                        if coord.x >= @drawer.width or coord.y >= @drawer.height
                            @drawer.drawCharacterKnowledge(@character)
                        else
                            @drawer.drawCellSelectOverlay(@character, @gameState, coord)

        coordFromMouseEvent: (e) ->
            return new Vec2(e.x, e.y)
            
        setDrawer: (@drawer) ->
        setCharacter: (@character) ->
        setGameState: (@gameState) ->
