define [
    'console/console'
    'util'
    'config'
], (GenericConsole, Util, Config) ->

    const KEYCODE_BACKSPACE = 127

    class Console extends GenericConsole.Console
        (@consoleWindow, @gameWindow, @ncurses) ->

            @consoleWindowCallback = (->)
            @consoleWindow.on 'inputChar', (c, k) ~>
                @consoleWindowCallback(c, k)

            @log = [""]
            @logIndex = 0
            @newLineOnNextPrint = false

            @refresh()

        setCurrentLogEntry: (str) ->
            @log[@logIndex] = str

        appendCurrentLogEntry: (str) ->
            @setCurrentLogEntry([@log[@logIndex], str].join(''))

        addNewLogEntry: ->
            ++@logIndex
            @setCurrentLogEntry("")

        refresh: ->
            @consoleWindow.clear()
            @consoleWindow.box()
            @consoleWindow.cursor(1, 1)
            visible = @log.slice(-10)

            for line in visible[0 til visible.length - 1]
                @consoleWindow.addstr(line)
                @consoleWindow.cursor(@consoleWindow.cury + 1, 1)
                
            @consoleWindow.addstr(visible[visible.length - 1])

            @consoleWindow.refresh()

        print: (str) ->
            if @newLineOnNextPrint
                @addNewLogEntry()
                @newLineOnNextPrint = false
            @appendCurrentLogEntry(str)
            @refresh()
            if Config.DEBUG_PRINT_CONSOLE
                Util.printDebug(str)

        newLine: ->
            @newLineOnNextPrint = true

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
                    @printLine(str)
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
            if not @newLineOnNextPrint
                @setCurrentLogEntry("")
                @refresh()

    {
        Console
    }
