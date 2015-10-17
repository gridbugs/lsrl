define [
], ->

    assert = (condition, message) ->
        if not condition
            throw message || "Assertion failed!"

    Chars = ['a' to 'z'] ++ ['A' to 'Z'] ++ ['0' to '9']

    Colours = {
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
        if Colours[char]?
            return Colours[char]
        else
            return def

    {
        assert
        Chars
        Colours
        getColour
    }
