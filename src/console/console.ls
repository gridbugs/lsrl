define [
], ->
    class Console
        printLine: (line) ->
            @print(line)
            @crlf()
    
    {
        Console
    }
