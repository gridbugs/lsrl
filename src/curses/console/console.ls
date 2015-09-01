define [
    'console/console'
], (GenericConsole) ->

    const KEYCODE_BACKSPACE = 127

    class Console extends GenericConsole.Console
        (@consoleWindow, @gameWindow, @ncurses) ->

            @consoleWindowCallback = (->)
            @consoleWindow.on 'inputChar', (c, k) ~>
                @consoleWindowCallback(c, k)

        print: (str) ->
            @consoleWindow.addstr(str)
            @consoleWindow.refresh()

        newLine: ->
            @consoleWindow.addstr("\n\r")
            @consoleWindow.refresh()

        readLineFiltered: (str, filter, callback) ->
            @ncurses.showCursor = true
            @consoleWindow.top()
            x = @consoleWindow.curx
            y = @consoleWindow.cury
            @consoleWindow.addstr(str)
            @consoleWindow.refresh()


            @consoleWindowCallback = (c, k) ~>
                if c == '\n'
                    @ncurses.showCursor = false
                    @gameWindow.top()
                    @gameWindow.refresh()
                    @consoleWindowCallback = (->)
                    @consoleWindow.addstr(c)
                    @consoleWindow.refresh()
                    callback(str)
                else if k == KEYCODE_BACKSPACE
                    str := str.slice(0, str.length - 1)
                    @consoleWindow.cursor(@consoleWindow.cury, Math.max(@consoleWindow.curx - 1, x))
                    @consoleWindow.delch()
                    @consoleWindow.refresh()
                else
                    if filter(c)
                        str += c
                        @consoleWindow.addstr(c)
                        @consoleWindow.refresh()

        readString: (default_string, callback) ->
            if not callback?
                callback = default_string
                default_string = ""

            @readLineFiltered(default_string, ->true, callback)

        readInteger: (default_int, callback) ->
            if callback?
                default_string = "#{default_int}"
            else
                callback = default_int
                default_string = ""

            result_string <-@readLineFiltered(default_string, ((c) -> not isNaN(parseInt(c))))
            ret = parseInt(result_string)
            if isNaN(ret)
                ret = 0
            callback(ret)

        clearLine: ->
            @consoleWindow.cursor(@consoleWindow.cury, 0)
            @consoleWindow.addstr("                                             ")
            @consoleWindow.cursor(@consoleWindow.cury, 0)

    {
        Console
    }
