define ->
    isInt = (x) -> x % 1 == 0
    getRandomElement = (arr) -> arr[parseInt(Math.random()*arr.length)]
    makeEnum = (arr) ->
        ret = {}
        i = 0
        for e in arr
            ret[e] = i++
        return ret

    getCharCode = (c) -> c.charCodeAt 0

    printTerminal = (x) -> process.stderr.write "#{x}\n"
    printBrowser = (x) -> console.debug x

    if console.debug?
        printDebug = printBrowser
    else
        printDebug = printTerminal

    printState = {
        drawer: void
    }

    setPrintDrawer = (d) -> printState.drawer = d
    print = (str) -> printState.drawer.print str

    {
        isInt
        makeEnum
        enum: makeEnum
        getRandomElement
        getCharCode
        setPrintDrawer
        print
        printDebug
    }
