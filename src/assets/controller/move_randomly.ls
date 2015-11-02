define [
    'system/controller'
    'assets/assets'
    'types'
    'structures/direction'
    'util'
    'asset_system'
], (Controller, Assets, Types, Direction, Util, AssetSystem) ->

    class MoveRandomly extends Controller
        (@character, @position, @grid) ->
            super()

        observe: (game_state) ->

        getAction: (game_state, callback) ->
            action = new Assets.Action.Move(@character, Util.getRandomElement(Direction.Directions))
            callback(action)

    AssetSystem.exposeAsset('Controller', MoveRandomly)
