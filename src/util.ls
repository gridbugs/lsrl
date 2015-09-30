define [
    'config'
], (Config) ->
    isInt = (x) -> x % 1 == 0
    getRandomElement = (arr) -> arr[parseInt(Math.random()*arr.length)]
    makeEnum = (arr) ->
        ret = {}
        i = 0
        for e in arr
            ret[e] = i++
        return ret

    getRandomFloat = (min, max) -> (Math.random() * (max - min)) + min
    getRandomInt = (min, max) -> parseInt(getRandomFloat(min, max))

    makeTable = (enum_type, object) ->
        arr = []
        for k, v of object
            arr[enum_type[k]] = v
        return arr

    mapTable = (enum_type, object, fn) ->
        arr = []
        for k, v of object
            arr[enum_type[k]] = fn(v)
        return arr

    joinTable = (enum_l, enum_r, object) ->
        arr = []
        for k, v of object
            arr[enum_l[k]] = enum_r[v]
        return arr

    joinSelf = (enum_type, obj) ->
        arr = []
        for k, v of obj
            arr[enum_type[k]] = enum_type[v]
        return arr

    joinTableArray = (enum_l, enum_r, object) ->
        arr = []
        for k, v of object
            arr[enum_l[k]] = enumValuesForKeys enum_r, v
        return arr

    joinTableArraySelf = (enum_type, object) ->
        joinTableArray enum_type, enum_type, object

    enumValuesForKeys = (e, keys) -> keys.map (e.)
    enumValues = (e) -> enumValuesForKeys(e, Object.keys(e))
    enumKeys = (e) ->
        arr = []
        for k, v of e
            arr[v] = k
        return arr

    getCharCode = (c) -> c.charCodeAt 0

    printTerminal = (x) -> process.stderr.write "#{x}\n"
    printBrowser = (x) -> console.debug x

    if Config.DEBUG_PRINTOUTS
        if console.debug?
            printDebug = printBrowser
        else
            printDebug = printTerminal
    else
        printDebug = ->

    constrain = (min, x, max) ->
        return Math.min(Math.max(x, min), max)

    shuffleArrayInPlace = (arr) ->
        for i from 0 til arr.length
            idx = i + Math.floor (Math.random! * (arr.length - i))
            tmp = arr[i]
            arr[i] = arr[idx]
            arr[idx] = tmp

    repeatWhileUndefined = (f, cb) ->
        f (a) ->
            if a?
                cb a
            else
                repeatWhileUndefined f, cb

    enumerate = (s) -> (s.map (x, i) -> [i, x])

    enumerateDefined = (s) -> enumerate(s).filter (x) -> x?

    objectKeyedByArray = (array, f = -> void) ->
        obj = {}
        for x in array
            obj[x] = f(x)
        return obj

    joinObject = (left, right) ->
        obj = {}
        for k, v of right
            obj[k] = left[v]
        return obj

    isAlpha = (str) ->
        return (str == /^[a-zA-Z]+$/)?

    createArray2d = (height, width) ->
        outer = new Array(height)
        for i from 0 til outer.length
            outer[i] = new Array(width)
        return outer


    createArray2dCalling = (height, width, fn) ->
        ret = createArray2d(height, width)
        for i from 0 til height
            for j from 0 til width
                ret[i][j] = fn(j, i)
        return ret

    packObject = (namespace, object) ->
        for k, v of object
            namespace[k] = v

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
        constrain
        shuffleArrayInPlace
        enumValues
        enumValuesForKeys
        joinArray: joinTableArray
        joinArraySelf: joinTableArraySelf
        joinSelf
        enumKeys
        repeatWhileUndefined
        enumerate
        enumerateDefined
        objectKeyedByArray
        joinObject
        getRandomFloat
        getRandomInt
        mapTable
        isAlpha
        createArray2d
        createArray2dCalling
        packObject
    }
