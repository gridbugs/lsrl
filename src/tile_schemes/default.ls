define [
    'cell/fixture'
    'structures/grid'
    'util'
    'types'
    'debug'
], (Fixture, Grid, Util, Types, Debug) ->

    const TileType = Util.enum([
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
        \Water2
        \Grass
        \Bridge
        \StoneDownwardStairs
        \StoneUpwardStairs
    ] ++ Debug.Chars)

    class SimpleTile
        (@tile) ->

        getTile: (cell) ->
            return @tile

    class DoorTile
        (@openTile, @closedTile) ->

        getTile: (cell) ->
            if cell.fixture.isOpen()
                return @openTile
            else
                return @closedTile

    class WaterTile
        (@frames) ->
            @currentIdx = Util.getRandomInt(0, @frames.length)
            @updateRemainingTurns()

        updateRemainingTurns: ->
            @remainingTurns = Util.getRandomInt(5, 15)

        getTile: (cell) ->
            ret = @frames[@currentIdx]
            --@remainingTurns
            if @remainingTurns == 0
                @updateRemainingTurns()
                @currentIdx = (@currentIdx + 1) % @frames.length
            return ret

    class TileCell
        (@x, @y) ->
            @fixture = void
            @fixtureTile = void
            @ground = void
            @groundTile = void

    class TileStateData
        (@width, @height, @scheme) ->
            @grid = new Grid(TileCell, @width, @height)

        getCachedFixture: (cell) ->
            cached = @grid.getCart(cell)
            if cached.fixture == cell.fixture
                return cached.fixtureTile.getTile(cell)
            cached.fixture = cell.fixture
            cached.fixtureTile = @scheme.fixtureTable[cell.fixture.type]()
            return cached.fixtureTile.getTile(cell)

        getCachedGround: (cell) ->
            cached = @grid.getCart(cell)
            if cached.ground == cell.ground
                return cached.groundTile.getTile(cell)
            cached.ground = cell.ground
            cached.groundTile = @scheme.groundTable[cell.ground.type]()
            return cached.groundTile.getTile(cell)

        getTileFromType: (type) ->
            return @scheme.tileSet[type]

        getTileFromCell: (cell, visible = true) ->

            if cell.character?
                if cell.character == @scheme.playerCharacter
                    return @scheme.tiles.PlayerCharacter
                return @scheme.flatCharacterTable[cell.character.type].getTile(cell)

            if cell.items.length() > 0
                top_item = cell.items.first()
                return @scheme.flatItemTable[top_item.type].getTile(cell)

            if cell.fixture.type != Types.Fixture.Null
                return @getCachedFixture(cell)

            return @getCachedGround(cell)

    class DefaultTileScheme

        /* tileSet is a mapping from tile number to a representation of the tile
         */
        (@tileSet) ->

            @tiles = Util.joinObjectTable TileType, @tileSet

            @fixtureTable = Util.table Types.Fixture, Util.mergeObjects({
                Wall:       ~> @simple(\Wall)
                Web:        ~> @simple(\SpiderWeb)
                Tree:       ~> @simple(\Tree)
                DirtWall:   ~> @simple(\DirtWall)
                BrickWall:  ~> @simple(\BrickWall)
                Bridge:     ~> @simple(\Bridge)
                StoneDownwardStairs:    ~> @simple(\StoneDownwardStairs)
                StoneUpwardStairs:      ~> @simple(\StoneUpwardStairs)

                Water:      ~> new WaterTile([@getTile(\Water), @getTile(\Water2)])

                Door:       ~> new DoorTile(@getTile(\OpenDoor), @getTile(\Door))

            }, {[char, ((c) ~> (~> @simple(c))) (char)] for char in Debug.Chars})

            @groundTable = Util.table Types.Ground, {
                Dirt:       ~> @simple(\Dirt)
                Stone:      ~> @simple(\Stone)
                Moss:       ~> @simple(\Moss)
                Grass:      ~> @simple(\Grass)
            }

            @itemTable = Util.table Types.Item, {
                Stone:      ~> @simple(\ItemStone)
                Plant:      ~> @simple(\ItemPlant)
            }

            @characterTable = Util.table Types.Character, {
                Human:                  ~> @simple(\Human)
                Shrubbery:              ~> @simple(\Shrubbery)
                PoisonShrubbery:        ~> @simple(\PoisonShrubbery)
                CarnivorousShrubbery:   ~> @simple(\CarnivorousShrubbery)
            }

            @flatFixtureTable = @createFlatTable(@fixtureTable)
            @flatGroundTable = @createFlatTable(@groundTable)
            @flatItemTable = @createFlatTable(@itemTable)
            @flatCharacterTable = @createFlatTable(@characterTable)

        createTileStateData: (width, height) ->
            return new TileStateData(width, height, this)

        createFlatTable: (constructor_table) ->
            ret = []
            for k, v of constructor_table
                ret[k] = v()
            return ret

        getTile: (name) ->
            return @tileSet[TileType[name]]

        simple: (name) ->
            return new SimpleTile(@getTile(name))

        setPlayerCharacter: (character) !->
            @playerCharacter = character

    DefaultTileScheme.TileType = TileType

    return DefaultTileScheme
