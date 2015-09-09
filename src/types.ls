define [
    'util'
], (Util) ->

    const Tile = Util.enum [
        \Error
        \Unknown
        \Stone
        \Dirt
        \Tree
        \Wall
        \SpiderWeb
        \Moss
        \ItemStone
        \ItemPlant
        \Door
        \OpenDoor
        \Human
        \Shrubbery
        \PlayerCharacter
    ]

    const Fixture = Util.enum [
        \Null
        \Wall
        \Web
        \Tree
        \Door
    ]

    const Ground = Util.enum [
        \Dirt
        \Stone
        \Moss
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
    ]

    const Item = Util.enum [
        \Stone
        \Plant
    ]

    const Event = Util.enum [
        \MoveToCell
        \MoveFromCell
        \CharacterMove
    ]

    const Character = Util.enum [
        \Human
        \Shrubbery
    ]

    {
        Tile
        Fixture
        Ground
        Direction
        CardinalDirection
        OrdinalDirection
        Control
        Item
        Event
        Character
    }
