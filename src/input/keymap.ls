define [
    'input/control'
    'util'
], (Control, Util) ->

    const DvorakKeys = {
        a: \a
        x: \b
        j: \c
        e: \d
        '.': \e
        u: \f
        i: \g
        d: \h
        c: \i
        h: \j
        t: \k
        n: \l
        m: \m
        b: \n
        r: \o
        l: \p
        "'": \q
        p: \r
        o: \s
        y: \t
        g: \u
        k: \v
        ',': \w
        q: \x
        f: \y
        ';': \z
        A: \A
        X: \B
        J: \C
        E: \D
        '>': \E
        U: \F
        I: \G
        D: \H
        C: \I
        H: \J
        T: \K
        N: \L
        M: \M
        B: \N
        R: \O
        L: \P
        '"': \Q
        P: \R
        O: \S
        Y: \T
        G: \U
        K: \V
        '<': \W
        Q: \X
        F: \Y
        ':': \Z
    }

    convertFromDvorak = (c) ->
        key = DvorakKeys[c]
        if key?
            return key
        else
            return c

    convertFromQwerty = (c) -> c

    const Controls = Util.joinObject Control.Controls, {
        h: \West
        j: \South
        k: \North
        l: \East
        y: \NorthWest
        u: \NorthEast
        b: \SouthWest
        n: \SouthEast
        H: \AutoWest
        J: \AutoSouth
        K: \AutoNorth
        L: \AutoEast
        Y: \AutoNorthWest
        U: \AutoNorthEast
        B: \AutoSouthWest
        N: \AutoSouthEast
        o: \AutoExplore
        X: \NavigateToCell
        '\r': \Accept
        '\n': \Accept
        (String.fromCharCode(27)): \Escape
        x: \Examine
        g: \Get
        d: \Drop
        i: \Inventory
    }

    {
        Controls
        convertFromQwerty
        convertFromDvorak
    }
