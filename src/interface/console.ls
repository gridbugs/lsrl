define [
], ->
    class Console
        printLine: (line) ->
            @print(line)
            @newLine()

        printDescriptionLine: (description) ->
            @printDescription(description)
            @newLine()
