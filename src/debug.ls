define [
], ->

    assert = (condition, message) ->
        if not condition
            throw message || "Assertion failed!"

    chars = ['a' to 'z'] ++ ['A' to 'Z'] ++ ['0' to '9']

    colours = {
        a: 'Purple'
        b: 'Magenta'
        c: 'Red'
        d: 'Pink'
        e: 'Orange'
        f: 'Yellow'
        g: 'Green'
        h: 'Cyan'
        i: 'Blue'
    }

    getColour = (char, def) ->
        if colours[char]?
            return colours[char]
        else
            return def

    {
        assert
        chars
        colours
        getColour
    }
