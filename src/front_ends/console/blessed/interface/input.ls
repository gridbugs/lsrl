define [
    'front_ends/console/input'
    'interface/keymap'
    'interface/key'
], (BaseInput, Keymap, Key) ->

    const ENTER_KEY = 13

    NameToCode = {
        left: Key.LEFT
        right: Key.RIGHT
        up: Key.UP
        down: Key.DOWN
        escape: Key.ESCAPE
    }

    class Input extends BaseInput
        (@program, convert = Keymap.convertFromQwerty) ->
            super(convert)

            @expectingSecondEnterKey = false

            @program.on 'keypress', (c, obj) ~>

                # Blessed sends the enter key twice when it is pressed once
                if @expectingSecondEnterKey and c? and c.charCodeAt(0) == ENTER_KEY
                    @expectingSecondEnterKey = false
                    return

                if c? and c.charCodeAt(0) == ENTER_KEY
                    @expectingSecondEnterKey = true

                code = NameToCode[obj.name]
                process.stderr.write '' + code + " |" +obj.name+ "|" + Object.keys(NameToCode) + "|" + NameToCode["left"] + "\n"
                if not code?
                    code = obj.name.charCodeAt(0)
                key = new Key(
                    obj.name,
                    code,
                    obj.shift,
                    obj.ctrl,
                    obj.meta
                )

                @handleInputKey(key)

