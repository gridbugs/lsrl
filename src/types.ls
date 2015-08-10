define [
    \util
], (Util) ->

    const Tile = Util.enum [
        \Error
        \Unknown
        \Stone
        \Dirt
        \Tree
        \Wall
        \SpiderWeb
    ]

    const Fixture = Util.enum [
        \Null
        \Wall
        \Web
        \Tree
    ]

    const Ground = Util.enum [
        \Dirt
        \Stone
    ]

    {
        Tile
        Fixture
        Ground
    }
