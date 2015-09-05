define [
    'console/console'
    'util'
    'config'
], (GenericConsole, Util, Config) ->

    const KEYCODE_ENTER = 13

    class Console extends GenericConsole.Console
        (@$consoleDiv) ->
            @newLine()

        print: (str) ->
            @$current.append("<span>#{str}</span>")
            @scrollToBottom()
            if Config.DEBUG_PRINT_CONSOLE
                Util.printDebug(str)


        newLine: ->
            @$current = $("<div class='line'>")
            @$consoleDiv.append(@$current)

        readLineInternal: ($field, initial, callback) ->
            @$current.append($field)
            $field.val(initial)

            document.onkeyup = ->
                $field.focus()
                $field.select()
                document.onkeyup = (->)

            $field.keypress (e) ~>
                if e.keyCode == KEYCODE_ENTER
                    result = $field.val()
                    $field.remove()
                    @printLine result
                    callback(result)

        readString: (default_string, callback) ->
            if not callback?
                callback = default_string
                default_string = ""

            $field = $("<input class='readString'>")

            @readLineInternal($field, default_string, callback)

        readInteger: (default_integer, callback) ->
            if callback?
                default_string = "#{default_integer}"
            else
                callback = default_integer
                default_string = ""

            $field = $("<input class='readInteger'>").numeric()

            result_string <- @readLineInternal($field, default_string)
            callback(parseInt(result_string))

        clearLine: ->
            @$current?.remove()
            @newLine()

        scrollToBottom: ->
            @$consoleDiv[0].scrollTop = @$consoleDiv[0].scrollHeight
    {
        Console
    }
