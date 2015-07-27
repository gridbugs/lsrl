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

    const Qwerty =
       h: Controls.WEST
       j: Controls.SOUTH
       k: Controls.NORTH
       l: Controls.EAST
       y: Controls.NORTHWEST
       u: Controls.NORTHEAST
       b: Controls.SOUTHWEST
       n: Controls.SOUTHEAST

    {
        Dvorak
        Qwerty
    }
