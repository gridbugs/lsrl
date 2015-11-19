define [
    'front_ends/console/input'
    'interface/key'
], (BaseInput, Key) ->

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

