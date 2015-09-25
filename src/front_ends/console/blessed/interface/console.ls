define [
    'interface/console'
    'front_ends/console/box'
    'front_ends/console/blessed/util'
    'front_ends/console/text'
    'front_ends/console/colours'
    'util'
], (BaseConsole, Box, BlessedUtil, Text, Colours, Util) ->

    const KEYCODE_BACKSPACE = 127

    class Console extends BaseConsole implements BlessedUtil.Boxable
        (@program, @input, @left, @top, @width, @height) ->
            @border = Box.BorderSingleLineUnicode

            @log = [""]
            @logIndex = 0
            @newLineOnNextPrint = false

            @numLines = @height - 2

            @drawBox()

        setCurrentLogEntry: (str) ->
            @log[@logIndex] = str

        appendCurrentLogEntry: (str) ->
            @setCurrentLogEntry([@log[@logIndex], str].join(''))

        addNewLogEntry: ->
            ++@logIndex
            @setCurrentLogEntry("")

        printLog: ->
            @program.write(Text.setForegroundColour(Colours.White))
            @program.write(Text.setNormalWeight())
            @program.move(@left + 1, @top + 1)
            visible = @log.slice(-@numLines)
            for line in visible[0 til visible.length - 1]
                @program.write("#{line}\n")
                @program.setx(@left + 1)
            @program.write(visible[visible.length - 1])

        refresh: ->
            @clear()
            @printLog()
            @program.flushBuffer()

        print: (str) ->
            if @newLineOnNextPrint
                @addNewLogEntry()
                @newLineOnNextPrint = false
            @appendCurrentLogEntry(str)
            @refresh()
        newLine: ->
            @newLineOnNextPrint = true
        clearLine: ->
            if not @newLineOnNextPrint
                @setCurrentLogEntry("")
                @refresh()

        readString: (default_string, callback) ->
            if not callback?
                callback = default_string
                default_string = ""

            @program.showCursor()

            @program.write(default_string)
            @program.flushBuffer()

            @filter = -> true
            @doReadString(default_string, callback)

        doReadString: (string, callback) ->
            @input.getCharNative (char) ~>

                if not char?
                    @doReadString(string, callback)
                else if char == '\r'
                    @program.hideCursor();
                    @printLine(string)
                    callback(string)
                else if char.charCodeAt(0) == KEYCODE_BACKSPACE
                    if string.length > 0
                        @program.back(1)
                        @program.write(' ')
                        @program.back(1)
                        @program.flushBuffer()
                    @doReadString(string.slice(0, string.length - 1), callback)
                else if @filter(char)
                    @program.write(char)
                    @program.flushBuffer()
                    @doReadString(string + char, callback)
                else
                    @doReadString(string, callback)

        readInteger: (default_int, callback) ->
            if callback?
                default_string = "#{default_int}"
            else
                callback = default_int
                default_string = ""

            @program.write(default_string)
            @program.flushBuffer()

            @filter = (c) -> not isNaN(parseInt(c))
            string <- @doReadString(default_string)
            num = parseInt(string)
            if isNaN(num)
                num = 0
            callback(num)
