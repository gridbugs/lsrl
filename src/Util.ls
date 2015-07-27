export isInt = (x) -> x % 1 == 0
export getRandomElement = (arr) -> arr[parseInt(Math.random()*arr.length)]
export makeEnum = (arr) ->
    ret = {}
    i = 0
    for e in arr
        ret[e] = i++
    return ret

export getCharCode = (c) -> c.charCodeAt 0

printState = {
    drawer: void
}
export setPrintDrawer = (d) -> printState.drawer = d
export print = (str) -> printState.drawer.print str
