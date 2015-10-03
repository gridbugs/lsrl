define [
], ->

    assert = (condition, message) ->
        if not condition
            throw message || "Assertion failed!"

    chars = ['a' to 'z'] ++ ['A' to 'Z'] ++ ['0' to '9']

    colours = {
        a: 'Red'
        b: 'Blue'
        c: 'Green'
        d: 'Yellow'
        e: 'Purple'
        f: 'Orange'
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
