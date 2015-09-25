define [
    'interface/console'
    'front_ends/console/box'
    'front_ends/console/blessed/util'
    'util'
], (BaseConsole, Box, BlessedUtil, Util) ->

    class Console extends BaseConsole implements BlessedUtil.Boxable
        (@program, @left, @top, @width, @height) ->
            @border = Box.BorderSingleLineUnicodeBold

            @log = [""]
            @logIndex = 0
            @newLineOnNextPrint = false

            @numLines = @height - 2

            @refresh()
        
        setCurrentLogEntry: (str) ->
            @log[@logIndex] = str

        appendCurrentLogEntry: (str) ->
            @setCurrentLogEntry([@log[@logIndex], str].join(''))
        
        addNewLogEntry: ->
            ++@logIndex
            @setCurrentLogEntry("")

        clear: ->
            @program.move(@left + 1, @top + 1)
            for i from 0 til @numLines
                @program.write(' ' * @width + '\n')
                @program.setx(@left + 1)

        printLog: ->
            @program.move(@left + 1, @top + 1)
            visible = @log.slice(-@numLines)
            for line in visible[0 til visible.length - 1]
                @program.write("#{line}\n")
                @program.setx(@left + 1)
            @program.write(visible[visible.length - 1])

        refresh: ->
            @clear()
            @drawBox()
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
        readString: ->
        readInteger: ->
