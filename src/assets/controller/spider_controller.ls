define [
    'system/controller'
    'assets/assets'
    'types'
    'structures/direction'
    'structures/search'
    'util'
    'asset_system'
    'debug'
], (Controller, Assets, Types, Direction, Search, Util, AssetSystem, Debug) ->

    getRandomMoveAction = (character) ->
        d = Util.getRandomElement(Direction.Directions)
        ret = new Assets.Action.Move(character, d)
        return ret

    pathThroughEmptyCells = (source, destination) ->
        return Search.findPath(source
            , (c, d) -> c.getMoveOutCost(d)
            , (c) -> c.feature.type == Types.Feature.Null or c.feature.type == Types.Feature.Bridge or c.feature.type == Types.Feature.Web
            , destination
        )

    class Attack
        (@character, @target) ->
        
        run: (game_state) ->
            path = pathThroughEmptyCells(@character.getCell(), @target.getCell())
            if path?
                if path.path.length == 1
                    return new Assets.Action.Attack(@character, path.directions[0])
                else
                    return new Assets.Action.Move(@character, path.directions[0])
            else
                return new Assets.Action.Wait(@character, 5)


    class Patrol
        (@character, @centre, @radius = 5) ->

        run: (game_state) ->
            action = getRandomMoveAction(@character)
            if @centre.distance(action.toCell) < @radius
                return action
            else
                path = pathThroughEmptyCells(@character.getCell(), @character.grid.getCart(@centre))
                if path? and path.path.length > 0
                    return new Assets.Action.Move(@character, path.directions[0])
                else
                    return new Assets.Action.Wait(@character, 5)


    class SpiderController extends Controller
        (@character, @position, @grid) ->
            super(@grid)
            @viewDistance = 20
            @viewDistanceSquared = @viewDistance * @viewDistance
            @startPosition = @position.clone()
            @patrol = new Patrol(@character, @startPosition)

        getAction: (game_state, callback) ->

            potential_targets = @knowledge.visibleCharacters.filter (c) ~>
                c.type == Types.Character.Human and c.position.distance(@character.position) < 10

            if potential_targets.length == 0
                action = @patrol.run(game_state)
                callback(action)
            else
                @attack = new Attack(@character, potential_targets[0])
                action = @attack.run(game_state)
                callback(action)

    AssetSystem.exposeAsset('Controller', SpiderController)
