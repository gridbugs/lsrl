define [
    'assets/assets'
    'system/cell'
    'system/knowledge'
    'asset_system'
    'util'
    'types'
], (Assets, Cell, Knowledge, AssetSystem, Util, Types) ->

    class Tile
        (@character, @colour, @bold) ->

    class Animator
        (@frames, @low = 8, @high = 16) ->
            @timeRemaining = Util.getRandomInt(0, @high)
            @tileIndex = Util.getRandomInt(0, @frames.length)

        progressTime: ->
            if @timeRemaining == 0
                @timeRemaining = Util.getRandomInt(@low, @high)
                ++@tileIndex
                if @tileIndex == @frames.length
                    @tileIndex = 0
            else
                --@timeRemaining

        getTile: ->
            return @frames[@tileIndex]

    AssetSystem.makeAsset 'TileSet', {
        displayName: 'UnicodeTileSet'
        init: ->
            tiles = {
                Error:                      ['?', 'LightRed',   false]
                Unknown:                    [' ', 'Black',      false]
                Stone:                      ['.', 'LightGrey',  false]
                Dirt:                       ['.', 'DarkBrown',  false]
                Tree:                       ['&', 'DarkGreen',  false]
                Wall:                       ['#', 'DarkGrey',   false]
                Web:                        ['*', 'LightGrey',  false]
                Moss:                       ['.', 'LightGreen', false]
                ItemStone:                  ['[', 'LightGrey',  false]
                ItemPlant:                  ['%', 'LightGreen', false]
                Door:                       ['+', 'LightGrey',  false]
                OpenDoor:                   ['-', 'LightGrey',  false]
                Human:                      ['h', 'White',      true]
                Shrubbery:                  ['p', 'DarkGreen',  true]
                PoisonShrubbery:            ['p', 'Purple',     true]
                CarnivorousShrubbery:       ['p', 'LightGreen', true]
                PlayerCharacter:            ['@', 'White',      true]
                DirtWall:                   ['#', 'DarkBrown',  false]
                BrickWall:                  ['#', 'LightRed',   false]
                Water0:                     ['~', 'Blue',       false]
                Water1:                     ['≈', 'Blue',       false]
                Grass:                      ['.', 'DarkGreen',  false]
                BridgeEastWest:             ['=', 'LightBrown', false]
                BridgeNorthSouth:           ['ǁ', 'LightBrown', false]
                StoneDownwardStairs:        ['>', 'DarkGrey',   true]
                StoneUpwardStairs:          ['<', 'DarkGrey',   true]
                Spider:                     ['s', 'White',      true]
            }

            @Tiles = {}
            for k, v of tiles
                @Tiles[k] = new Tile(v[0], Assets.Colour[v[1]], v[2])

        install: ->
            @init()

            tiles = @Tiles

            Knowledge.KnowledgeCell::getTile = ->
                if @character?
                    if @character.getTile?
                        return @character.getTile()
                    else
                        return tiles.Error
                else if @feature.type != Types.Feature.Null
                    if @feature.getTile?
                        return @feature.getTile()
                    else
                        return tiles.Error
                else if @ground.getTile?
                    return @ground.getTile()
                else
                    return tiles.Error

            # Features
            Assets.Feature.Tree::getTile = ->
                return tiles.Tree

            Assets.Feature.StoneDownwardStairs::getTile = ->
                return tiles.StoneDownwardStairs
            
            Assets.Feature.StoneUpwardStairs::getTile = ->
                return tiles.StoneUpwardStairs

            Assets.Feature.Water::getTile = ->
                if not @UnicodeTileSet_Animator?
                    @UnicodeTileSet_Animator = new Animator([tiles.Water0, tiles.Water1])

                @UnicodeTileSet_Animator.progressTime()
                return @UnicodeTileSet_Animator.getTile()
            
            Assets.Feature.Bridge::getTile = ->
                if @direction == Types.Direction.North
                    return tiles.BridgeNorthSouth
                else
                    return tiles.BridgeEastWest
            
            Assets.Feature.Web::getTile = ->
                return tiles.Web
            
            Assets.Feature.Wall::getTile = ->
                return tiles.Wall
            
            Assets.Feature.Door::getTile = ->
                if @isOpen()
                    return tiles.OpenDoor
                else
                    return tiles.Door

            # Ground
            Assets.Ground.Grass::getTile = ->
                return tiles.Grass
            
            Assets.Ground.Dirt::getTile = ->
                return tiles.Dirt
            
            Assets.Ground.Stone::getTile = ->
                return tiles.Stone

            # Characters
            Assets.Character.Spider::getTile = ->
                return tiles.Spider


        installPlayerCharacter: (pc) ->
            tiles = @Tiles

            pc.getTile = ->
                return tiles.PlayerCharacter

    }