define [
    'util'
    'debug'
], (Util, Debug) ->

    const Tile = Util.enum([
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
        \PoisonShrubbery
        \CarnivorousShrubbery
        \PlayerCharacter
        \BrickWall
        \DirtWall
        \Water
        \Grass
        \Bridge
    ] ++ Debug.chars)

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
    ] ++ Debug.chars)

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

    const Character = Util.enum [
        \Human
        \Shrubbery
        \PoisonShrubbery
        \CarnivorousShrubbery
    ]

    const Damage = Util.enum [
        \Physical
        \Poison
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
        Damage
    }
