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
        \Moss
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
        \Moss
    ]

    {
        Tile
        Fixture
        Ground
    }
