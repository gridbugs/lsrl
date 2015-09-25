define [
], ->
    {
        setForegroundColour: (colour) -> "\x1b[38;5;#{colour}m"
        setBackgroundColour: (colour) -> "\x1b[48;5;#{colour}m"
        setBoldWeight: -> "\x1b[1m"
        setNormalWeight: -> "\x1b[22m"
    }
