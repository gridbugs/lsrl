define [
    'util'
    'debug'
], (Util, Debug) ->

    const Fixture = Util.enum([
        \Null
        \Wall
        \Web
        \Tree
        \Door
        \BrickWall
        \DirtWall
        \Water
        \Bridge
        \StoneDownwardStairs
        \StoneUpwardStairs
    ] ++ Debug.Chars)

    const Ground = Util.enum [
        \Dirt
        \Stone
        \Moss
        \Grass
    ]

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
    ]

    const Item = Util.enum [
        \Stone
        \Plant
    ]

    const Event = Util.enum [
        \MoveToCell
        \MoveFromCell
        \CharacterMove
        \Death
    ]

    const Damage = Util.enum [
        \Physical
        \Poison
    ]

    {
        Fixture
        Ground
        Direction
        CardinalDirection
        OrdinalDirection
        Control
        Item
        Event
        Damage
    }
