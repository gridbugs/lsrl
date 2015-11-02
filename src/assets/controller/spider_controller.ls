define [
    'system/controller'
    'assets/assets'
    'types'
    'asset_system'
], (Controller, Assets, Types, AssetSystem) ->
    Action = Assets.Action

    class SpiderController extends Controller
        (@character, @position, @grid) ->
            super()

        getAction: (game_state, callback) ->
            action = new Action.Move(@character, Types.Direction.North)
            callback(action)

    AssetSystem.exposeAsset('Controller', SpiderController)
