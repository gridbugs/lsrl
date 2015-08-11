define [\control], (control) ->

    Controls = control.Controls

    const Dvorak =
        d: Controls.WEST
        h: Controls.SOUTH
        t: Controls.NORTH
        n: Controls.EAST
        f: Controls.NORTHWEST
        g: Controls.NORTHEAST
        x: Controls.SOUTHWEST
        b: Controls.SOUTHEAST
        D: Controls.AUTO_WEST
        H: Controls.AUTO_SOUTH
        T: Controls.AUTO_NORTH
        N: Controls.AUTO_EAST
        F: Controls.AUTO_NORTHWEST
        G: Controls.AUTO_NORTHEAST
        X: Controls.AUTO_SOUTHWEST
        B: Controls.AUTO_SOUTHEAST



    const Qwerty =
       h: Controls.WEST
       j: Controls.SOUTH
       k: Controls.NORTH
       l: Controls.EAST
       y: Controls.NORTHWEST
       u: Controls.NORTHEAST
       b: Controls.SOUTHWEST
       n: Controls.SOUTHEAST
       H: Controls.AUTO_WEST
       J: Controls.AUTO_SOUTH
       K: Controls.AUTO_NORTH
       L: Controls.AUTO_EAST
       Y: Controls.AUTO_NORTHWEST
       U: Controls.AUTO_NORTHEAST
       B: Controls.AUTO_SOUTHWEST
       N: Controls.AUTO_SOUTHEAST

    {
        Dvorak
        Qwerty
    }
