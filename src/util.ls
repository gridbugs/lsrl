define ->
    isInt = (x) -> x % 1 == 0
    getRandomElement = (arr) -> arr[parseInt(Math.random()*arr.length)]
    makeEnum = (arr) ->
        ret = {}
        i = 0
        for e in arr
            ret[e] = i++
        return ret

    makeTable = (enum_type, object) ->
        arr = []
        for k, v of object
            arr[enum_type[k]] = v
        return arr

    joinTable = (enum_l, enum_r, object) ->
        arr = []
        for k, v of object
            arr[enum_l[k]] = enum_r[v]
        return arr

    getCharCode = (c) -> c.charCodeAt 0

    printTerminal = (x) -> process.stderr.write "#{x}\n"
    printBrowser = (x) -> console.debug x

    if console.debug?
        printDebug = printBrowser
    else
        printDebug = printTerminal

    drawer = null
    setDrawer = (d) -> @drawer = d
    printDrawer = (str) ->
        @drawer.print str

    constrain = (min, x, max) ->
        return Math.min(Math.max(x, min), max)

    shuffleArrayInPlace = (arr) ->
        for i from 0 til arr.length
            idx = i + Math.floor (Math.random! * (arr.length - i))
            tmp = arr[i]
            arr[i] = arr[idx]
            arr[idx] = tmp

    {
        isInt
        makeEnum
        enum: makeEnum
        table: makeTable
        join: joinTable
        getRandomElement
        getCharCode
        print: printDebug
        printDebug
        setDrawer
        printDrawer
        constrain
        shuffleArrayInPlace
    }
