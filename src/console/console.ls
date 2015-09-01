define [
], ->
    class Console
        printLine: (line) ->
            @print(line)
            @newLine()

    {
        Console
    }
