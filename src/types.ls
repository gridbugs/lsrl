define [
    'util'
    'debug'
], (Util, Debug) ->

    const Direction = Util.enum [
        \North
        \East
        \South
        \West
        \NorthEast
        \SouthEast
        \SouthWest
        \NorthWest
    ]

    const CardinalDirection = Util.enum [
        \North
        \East
        \South
        \West
    ]

    const OrdinalDirection = Util.enum [
        \NorthEast
        \SouthEast
        \SouthWest
        \NorthWest
    ]

    const Control = Util.enum [
        \Direction
        \Action
        \Menu
        \AutoDirection
        \AutoExplore
        \NavigateToCell
        \Accept
        \Escape
        \Examine
        \Get
        \Drop
        \Inventory
        \Test
        \Wait
        \Descend
        \Ascend
        \Equip
    ]

    {
        Direction
        CardinalDirection
        OrdinalDirection
        Control
    }
