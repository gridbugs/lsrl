define [\control], (control) ->

    Controls = control.Controls

    const Dvorak = {
        d: Controls.West
        h: Controls.South
        t: Controls.North
        n: Controls.East
        f: Controls.NorthWest
        g: Controls.NorthEast
        x: Controls.SouthWest
        b: Controls.SouthEast
        D: Controls.AutoWest
        H: Controls.AutoSouth
        T: Controls.AutoNorth
        N: Controls.AutoEast
        F: Controls.AutoNorthWest
        G: Controls.AutoNorthEast
        X: Controls.AutoSouthWest
        B: Controls.AutoSouthEast
        r: Controls.AutoExplore
        Q: Controls.NavigateToCell
        '\r': Controls.Accept
        '\n': Controls.Accept
        (String.fromCharCode(27)): Controls.Escape
    }


    const Qwerty =
        h: Controls.West
        j: Controls.South
        k: Controls.North
        l: Controls.East
        y: Controls.NorthWest
        u: Controls.NorthEast
        b: Controls.SouthWest
        n: Controls.SouthEast
        H: Controls.AutoWest
        J: Controls.AutoSouth
        K: Controls.AutoNorth
        L: Controls.AutoEast
        Y: Controls.AutoNorthWest
        U: Controls.AutoNorthEast
        B: Controls.AutoSouthWest
        N: Controls.AutoSouthEast
        o: Controls.AutoExplore
        X: Controls.NavigateToCell
        '\r': Controls.Accept
        '\n': Controls.Accept
        (String.fromCharCode(27)): Controls.Escape

    {
        Dvorak
        Qwerty
    }
